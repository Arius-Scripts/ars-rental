local DrawMarker                  = DrawMarker
local IsEntityDead                = IsEntityDead
local IsControlJustPressed        = IsControlJustPressed
local AddBlipForCoord             = AddBlipForCoord
local SetBlipSprite               = SetBlipSprite
local SetBlipDisplay              = SetBlipDisplay
local SetBlipScale                = SetBlipScale
local SetBlipColour               = SetBlipColour
local SetBlipAsShortRange         = SetBlipAsShortRange
local BeginTextCommandSetBlipName = BeginTextCommandSetBlipName
local AddTextComponentString      = AddTextComponentString
local EndTextCommandSetBlipName   = EndTextCommandSetBlipName
local positions                   = {}

local function onEnter(self)
    if Config.Target then
        if not self.ped then
            local ped = utils.createPed(self.rental.pedModel, self.rental.pos)

            exports.ox_target:addLocalEntity(ped, {
                {
                    name = "rental_ped" .. ped,
                    label = "Interact",
                    icon = 'fa-solid fa-car',
                    onSelect = function(entity)
                        openRentalMenu(self.rental)
                    end
                }
            })

            self.ped = ped
        end
    else
        lib.showTextUI('[E] - Interact',
            {
                position = "top-center",
                icon = 'hand',
                style = { borderRadius = 0, backgroundColor = '#3a4d57', color = 'white' }
            })
    end
end

local function onExit(self)
    lib.hideTextUI()

    if self.ped then
        DeletePed(self.ped)
        self.ped = nil
    end
end

local function onNearby(self)
    if not Config.Target then
        DrawMarker(21, self.coords.x, self.coords.y, self.coords.z - 1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.6, 0.6, 0.6, 58,
            77, 87, 200, false, true, 2, nil, nil, false)
    end

    if self.currentDistance < 2 and not IsEntityDead(cache.ped) and IsControlJustPressed(0, 38) then
        openRentalMenu(self.rental)
    end
end

for i = 1, #Config.Rentals do
    local cfg = Config.Rentals[i]

    if cfg.blip.enable then
        local blip = AddBlipForCoord(cfg.pos.xy)
        SetBlipSprite(blip, cfg.blip.type)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, cfg.blip.scale)
        SetBlipColour(blip, cfg.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(cfg.blip.name)
        EndTextCommandSetBlipName(blip)
    end

    positions[i] = lib.points.new({
        coords = cfg.pos.xyz,
        distance = Config.Target and 60 or 5,
        rental = cfg,
        onEnter = onEnter,
        onExit = onExit,
        nearby = onNearby
    })
end
