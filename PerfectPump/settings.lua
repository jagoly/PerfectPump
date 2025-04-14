-- Perfect Pump by jagoly

data:extend({
    ---@type data.ModStringSettingPrototype
    {
        type = "string-setting",
        name = "perfect-pump-size",
        order = "aa",
        setting_type = "startup",
        default_value = "3x2",
        allowed_values = { "3x2", "1x2" },
    },
    ---@type data.ModStringSettingPrototype
    {
        type = "string-setting",
        name = "perfect-pump-speed",
        order = "ab",
        setting_type = "startup",
        default_value = "auto",
        allowed_values = { "auto", "40", "400" },
    },
})
