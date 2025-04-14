-- Perfect Pump by jagoly

--------------------------------------------------------------------------------

---@class (exact) PerfectPump.Pump
---@field public entity LuaEntity
---@field public input_entity LuaEntity?
---@field public input_search_filter EntitySearchFilters?

---@class (exact) PerfectPump.Storage
---@field public pumps {[uint]: PerfectPump.Pump}

---@type PerfectPump.Storage
storage = storage

--------------------------------------------------------------------------------

local function on_entity_built(event)
    local entity = event.entity or event.created_entity ---@type LuaEntity

    local fluidbox = entity.fluidbox
    local connections = fluidbox.get_pipe_connections(1)

    if entity.name == "perfect-pump" then
        local pump = { entity = entity }

        local input_connection = connections[2]
        local input_target = input_connection.target
        if input_target then 
            pump.input_entity = input_target.owner
        else
            pump.input_search_filter = { position = input_connection.target_position, type = "fluid-wagon" }
        end

        storage.pumps[entity.unit_number] = pump
    end
end

local function on_entity_broken(event)
    local entity = event.entity or event.ghost ---@type LuaEntity

    if entity.name == "perfect-pump" then
        storage.pumps[entity.unit_number] = nil
    end
end

--------------------------------------------------------------------------------

---@param event EventData.on_pre_surface_cleared|EventData.on_pre_surface_deleted
local function on_surface_cleared(event)
    local surface = assert(game.get_surface(event.surface_index))

    for _, entity in pairs(surface.find_entities_filtered({ name = "perfect-pump" })) do
        storage.pumps[entity.unit_number] = nil
    end
end

--------------------------------------------------------------------------------

local function on_init()
    storage.pumps = {}
end

--------------------------------------------------------------------------------

local status_working, status_low_power = defines.entity_status.working, defines.entity_status.low_power

local function on_tick()
    for _, pump in pairs(storage.pumps) do
        local entity = pump.entity
        local status = entity.status
        if status == status_working or status == status_low_power then
            local input_entity = pump.input_entity or entity.surface.find_entities_filtered(pump.input_search_filter)[1]
            if input_entity then
                local input_fluid = input_entity.get_fluid(1)
                if input_fluid then
                    local amount = entity.insert_fluid(input_fluid)
                    if amount > 0.0 then
                        input_entity.remove_fluid({ name = input_fluid.name, amount = amount })
                    end
                end
            end
        end
    end
end

--------------------------------------------------------------------------------

local filter_entities = {
    { filter = "name", name = "perfect-pump" },
    -- { filter = "type", type = "pipe" },
    -- { filter = "type", type = "pipe-to-ground" },
    -- { filter = "type", type = "storage-tank" },
}

script.on_event(defines.events.on_built_entity, on_entity_built, filter_entities)
script.on_event(defines.events.on_entity_cloned, on_entity_built, filter_entities)
script.on_event(defines.events.on_robot_built_entity, on_entity_built, filter_entities)
script.on_event(defines.events.script_raised_built, on_entity_built, filter_entities)
script.on_event(defines.events.script_raised_revive, on_entity_built, filter_entities)

script.on_event(defines.events.on_entity_died, on_entity_broken, filter_entities)
script.on_event(defines.events.on_pre_player_mined_item, on_entity_broken, filter_entities)
script.on_event(defines.events.on_robot_pre_mined, on_entity_broken, filter_entities)
script.on_event(defines.events.script_raised_destroy, on_entity_broken, filter_entities)

-- script.on_event(defines.events.on_player_rotated_entity, on_entity_rotated)

script.on_event(defines.events.on_pre_surface_cleared, on_surface_cleared)
script.on_event(defines.events.on_pre_surface_deleted, on_surface_cleared)

script.on_init(on_init)

script.on_event(defines.events.on_tick, on_tick)
