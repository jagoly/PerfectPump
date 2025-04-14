-- Perfect Pump by jagoly

--------------------------------------------------------------------------------

local entity = data.raw["pump"]["perfect-pump"] --[[@as data.PumpPrototype]]

local speed_string = settings.startup["perfect-pump-speed"].value --[[@as string]]
if speed_string == "auto" then
    entity.pumping_speed = data.raw["pump"]["pump"].pumping_speed * 2
else
    entity.pumping_speed = assert(tonumber(speed_string))
end

entity.fluid_box.volume = entity.pumping_speed
