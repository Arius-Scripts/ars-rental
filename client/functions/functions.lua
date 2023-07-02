local rentedCar = false

local function spawnRentalCar(vehicle, spawnPos, time)
    local playerPed = cache.ped

    DoScreenFadeOut(500)
    Wait(500)

    local rentalCar = utils.createVehicle(vehicle, spawnPos, true, false)

    lib.setVehicleProperties(rentalCar, { plate = Config.PlatePrefix })

    Wait(500)
    DoScreenFadeIn(600)

    rentedCar = true
    utils.showNotification("You rented a vehicle", "success")

    TaskEnterVehicle(playerPed, rentalCar, -1, -1, 1.0, 1, 0)

    SetTimeout(time, function()
        if rentalCar then
            if cache.vehicle then
                TaskLeaveVehicle(playerPed, rentalCar, 0)

                while cache.vehicle do
                    Wait(10)
                end

                Wait(500)
                NetworkFadeOutEntity(rentalCar, true, true)
                Wait(100)

                DeleteVehicle(rentalCar)
                utils.showNotification("Vehicle returned to the Ars Rental Time UP", "success")
                rentedCar = false
            else
                if DoesEntityExist(rentalCar) then
                    DeleteVehicle(rentalCar)
                end

                utils.showNotification("Vehicle returned to the Ars Rental Time UP", "success")
                rentedCar = false
            end
        end
    end)
end

local function calculateRentalCost(price, time, method)
    local cost = 0

    if method == "minutes" then
        cost = math.ceil(price * Config.mpMinutes * time / 200)
        time = time * 60000
    elseif method == "hours" then
        cost = math.ceil(price * Config.mpHours * time / 100)
        time = time * 3600000
    end

    return cost, time
end

local function rentCar(car, price, sp)
    if rentedCar then return end

    local input = lib.inputDialog('Ars Rental', {
        { type = "number", label = "Time", default = 1 },
        {
            type = "select",
            label = "Time",
            default = "minutes",
            options = {
                { value = "minutes", "Minutes" },
                { value = "Hours",   "Hours" },
            }
        },
    })

    if not input then return end

    local time = input[1]
    local method = input[2]

    local rentalCost, rentalTime = calculateRentalCost(price, time, method)
    local money = exports.ox_inventory:Search("count", "money", nil)

    if money >= rentalCost then
        local alert = lib.alertDialog({
            header = 'Ars Rental',
            content = 'Are you sure you want to  continue? \n the total price would be ' .. rentalCost .. "$",
            centered = true,
            cancel = true
        })
        if alert == "confirm" then
            TriggerServerEvent("ars-rental:removeMoney", rentalCost)
            spawnRentalCar(car, sp, rentalTime)
        end
    else
        utils.showNotification("You dont have enough money", "error")
    end
end

function openRentalMenu(data)
    local vehicles = {}

    for i = 1, #data.vehicles, 1 do
        local vehicle = data.vehicles[i]
        table.insert(vehicles, {
            title = vehicle.label,
            description = "Price $" .. vehicle.price,
            icon = vehicle.image and vehicle.image or
                "https://cdn.discordapp.com/attachments/1017732810200596500/1102271364313907220/logo.png",
            onSelect = function()
                rentCar(vehicle.car, vehicle.price, vehicle.spawnPosition)
            end,
        })
    end

    lib.registerContext({
        id = 'ars_rental_menu',
        title = 'Rent vehicle',
        options = vehicles
    })

    lib.showContext('ars_rental_menu')
end
