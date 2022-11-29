Config = {}

-- Multiplier per second/minutes/hours
Config.mpSeconds = 1 -- price * Config.Seconds * time >> es. 30000 * 1 * 15 / 360
Config.mpMinutes = 60 -- price * Config.Minutes * time >> es. 30000 * 60 * 15 / 200
Config.mpHours = 360 -- price * Config.Hours * time >> es. 30000 * 360 * 15 / 360


Config.PlatePrefix = "RENTAL"

Config.Positions = {
    ["1"] = {
        pos = vector3(-1059, -2718, 21),
        vehicles = {
            {label = "adder", car = "adder", price = 30000, spawnPosition = vector4(-1054, -2716, 21, 52)},
            {label = "bmx", car = "bmx", price = 250, spawnPosition = vector4(-1054, -2716, 21, 52)},
            {label = "zentorno", car = "zentorno", price = 35000, spawnPosition = vector4(-1054, -2716, 21, 52)},
        }
    },
    -- ["2"] = {
    --     pos = vector3(-1076, -2703, 21),
    --     vehicles = {
    --         {label = "dsa", car = "adder", price = 20, spawnPosition = vector4(-1054, -2716, 21, 52)},
    --         {label = "dsa", car = "bmx", price = 12, spawnPosition = vector4(-1054, -2716, 21, 52)},
    --         {label = "dsa", car = "zentorno", price = 1231, spawnPosition = vector4(-1054, -2716, 21, 52)},
    --     }
    -- },
}

