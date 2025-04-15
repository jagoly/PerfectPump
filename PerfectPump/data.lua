-- Perfect Pump by jagoly

--------------------------------------------------------------------------------

local entity = table.deepcopy(data.raw["pump"]["pump"]) --[[@as data.PumpPrototype]]
entity.name = "perfect-pump"
entity.icon = "__PerfectPump__/graphics/icon.png"
entity.minable.result = "perfect-pump"
entity.energy_source.drain = "20kW"
entity.energy_usage = "180kW"
entity.fluid_wagon_connector_speed = 2.0 / 64.0 -- double speed
entity.flow_scaling = false

local size_string = settings.startup["perfect-pump-size"].value --[[@as string]]
if size_string == "3x2" then
    entity.collision_box = { { -1.29, -0.9 }, { 1.29, 0.9 } }
    entity.selection_box = { { -1.5, -1.0 }, { 1.5, 1.0 } }
    entity.animations.north = {
        layers = {
            {
                filename = "__PerfectPump__/graphics/platform.png",
                x = 0, y = 32,
                width = 192, height = 128,
                scale = 0.5,
                repeat_count = entity.animations.north.frame_count,
            },
            entity.animations.north,
        },
    }
    entity.animations.east = {
        layers = {
            {
                filename = "__PerfectPump__/graphics/platform.png",
                x = 192, y = 0,
                width = 128, height = 192,
                scale = 0.5,
                repeat_count = entity.animations.east.frame_count,
            },
            entity.animations.east,
        },
    }
    entity.animations.south = {
        layers = {
            {
                filename = "__PerfectPump__/graphics/platform.png",
                x = 320, y = 32,
                width = 192, height = 128,
                scale = 0.5,
                repeat_count = entity.animations.south.frame_count,
            },
            entity.animations.south,
        },
    }
    entity.animations.west = {
        layers = {
            {
                filename = "__PerfectPump__/graphics/platform.png",
                x = 512, y = 0,
                width = 128, height = 192,
                scale = 0.5,
                repeat_count = entity.animations.west.frame_count,
            },
            entity.animations.west,
        },
    }
end

--------------------------------------------------------------------------------

local item = table.deepcopy(data.raw["item"]["pump"]) --[[@as data.ItemPrototype]]
item.name = "perfect-pump"
item.icon = "__PerfectPump__/graphics/icon.png"
item.place_result = "perfect-pump"

--------------------------------------------------------------------------------

local recipe = table.deepcopy(data.raw["recipe"]["pump"]) --[[@as data.RecipePrototype]]
recipe.name = "perfect-pump"
recipe.icon = "__PerfectPump__/graphics/icon.png"
recipe.results = {
    { type = "item", name = "perfect-pump", amount = 1 }
}
recipe.ingredients = {
    { type = "item", name = "pump", amount = 1 },
    { type = "item", name = "electronic-circuit", amount = 1 },
    { type = "item", name = "storage-tank", amount = 1 },
}
recipe.enabled = false

if mods["pypostprocessing"] then
    recipe.ingredients[4] = { type = "item", name = "intermetallics", amount = 5 }
    recipe.ingredients[5] = { type = "item", name = "gearbox-mk01", amount = 1 }
    recipe.ingredients[6] = { type = "item", name = "shaft-mk01", amount = 2 }
end

--------------------------------------------------------------------------------

---@type data.TechnologyPrototype
local technology = {
    type = "technology",
    name = "perfect-pump",
    effects = {
        { type = "unlock-recipe", recipe = "perfect-pump" },
    },
    prerequisites = { "fluid-wagon" },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack", 1 },
        },
        time = 30,
    },
    icon = "__PerfectPump__/graphics/technology.png",
    icon_size = 256,
}

if mods["pypostprocessing"] then
    technology.unit.ingredients[2][1] = "py-science-pack-1"
end

--------------------------------------------------------------------------------

data:extend({ entity, item, recipe, technology })
