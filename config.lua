Config = {}

Config.Target = true

-- Multiplier per second/minutes/hours
Config.mpSeconds = 1  -- price * Config.Seconds * time >> es. 30000 * 1 * 15 / 360
Config.mpMinutes = 60 -- price * Config.Minutes * time >> es. 30000 * 60 * 15 / 200
Config.mpHours = 360  -- price * Config.Hours * time >> es. 30000 * 360 * 15 / 360

Config.PlatePrefix = "RENTAL"

Config.Rentals = {
    {
        pos = vector4(-1058.2222900391, -2717.5029296875, 19.02063369751, 321.99890136719),
        pedModel = "a_m_m_bevhills_02",
        blip = {
            enable = true,
            type   = 778,
            color  = 54,
            scale  = 0.8,
            name   = "Ars Rental"
        },
        vehicles = {
            { label = "adder",    car = "adder",    price = 30000, spawnPosition = vector4(-1054, -2716, 21, 52) },
            { label = "bmx",      car = "bmx",      price = 250,   spawnPosition = vector4(-1054, -2716, 21, 52) },
            { label = "zentorno", car = "zentorno", price = 35000, spawnPosition = vector4(-1054, -2716, 21, 52) },
        }
    },
}
