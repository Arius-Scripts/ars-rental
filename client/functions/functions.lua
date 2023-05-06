local rentedCar = false

local function spawnRentalCar(vehicle, spawnPos, time)
    local playerPed = cache.ped

    DoScreenFadeOut(500)
    Wait(500)

    local rentalCar = createVehicle(vehicle, spawnPos, true, false)

    lib.setVehicleProperties(rentalCar, {plate = Config.PlatePrefix})

    Wait(500)
    DoScreenFadeIn(600)
    
    rentedCar = true
    notify("You rented a vehicle", "success")

    TaskEnterVehicle(playerPed, rentalCar, -1, -1, 1.0, 1, 0)

    SetTimeout(time, function()
        local rentedVehicle = rentalCar

        local plate = lib.getVehicleProperties(rentedVehicle).plate


        if cache.vehicle and string.match(plate, Config.PlatePrefix) then
            
            TaskLeaveVehicle(playerPed, rentedVehicle, 0)
            
            while IsPedInVehicle(playerPed, rentedVehicle, true) do
                Wait(0)
            end
            
            Wait(500)
            NetworkFadeOutEntity(rentedVehicle, true, true)
            Wait(100)
            
            DeleteVehicle(rentedVehicle)
            notify("Vehicle returned to the Ars Rental Time UP", "success")
            rentedCar = false
        else

            if DoesEntityExist(rentalCar) then
                DeleteVehicle(rentalCar)
            end

            notify("Vehicle returned to the Ars Rental Time UP", "success")
            rentedCar = false
        end
    end)
end

local function rentCar(car, price, sp)

    local input = lib.inputDialog('Ars Rental', {
        { type = "number", label = "Time", default = 1 },
        { type = "select", label = "Time", default = "seconds", options = {
            {value = "seconds", "Seconds"},
            {value = "minutes", "Minutes"},
            {value = "Hours", "Hours"},
        }},

    })
    
    if not input then return end

    local time = input[1]
    local method = input[2]

    if method == "seconds" then
        price = math.ceil(price * Config.mpSeconds * time / 360)
        time = time * 1000
    end

    if method == "minutes" then
        price = math.ceil(price * Config.mpMinutes * time / 200)
        time = time * 60000
    end

    if hours == "hours" then
        price = math.ceil(price * Config.mpHours * time / 100)
        time = time * 3600000
    end

    lib.callback('ars-rental:checkMoney', false, function(money)
        if money >= price then
            local alert = lib.alertDialog({
                header = 'Ars Rental',
                content = 'Are you sure you want to  continue? \n the total price would be '..price.."$",
                centered = true,
                cancel = true
            })
            if alert == "confirm" then
                TriggerServerEvent("ars-rental:removeMoney", price)
                spawnRentalCar(car, sp, time)
            end
        else
            notify("You dont have enough money", "error")
        end
    end)

end

function rentalMenu(zone)
    local vehicles = {}

    for i=1, #Config.Positions[zone].vehicles, 1 do
        local vehicle = Config.Positions[zone].vehicles[i]
        table.insert(vehicles, {
            label = vehicle.label, description = "Price $"..vehicle.price, args = {car = vehicle.car, price = vehicle.price, sp = vehicle.spawnPosition}
        })
    end

    lib.registerMenu({
        id = 'rantal',
        title = '|Ars Rental|',
        position = 'top-right',
        options =  vehicles
    }, function(selected, scrollIndex, args)
        if args and not rentedCar then
            rentCar(args.car, args.price, args.sp)
        else
            notify("you already have an rented car outside", "error")
        end
    end)
    
    lib.showMenu('rantal')
end

