local rentedCar = false


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


function rentCar(car, price, sp)

    local input = lib.inputDialog('Ars Rental', {
        { type = "number", label = "Time", default = 1 },
        { type = "checkbox", label = "Seconds", checked = false },
        { type = "checkbox", label = "Minutes", checked = true },
        { type = "checkbox", label = "Hours", checked = false },
    })
    
    if input then 
        time = input[1]
        seconds = input[2]
        minutes = input[3]
        hours = input[4]

        if seconds then
            price = math.ceil(price * Config.mpSeconds * time / 360)
            time = time * 1000
        elseif minutes then
            price = math.ceil(price * Config.mpMinutes * time / 200)
            time = time * 60000
        elseif hours then
            price = math.ceil(price * Config.mpHours * time / 100)
            time = time * 3600000
        end


        if seconds and minutes or minutes and hours or seconds and hours then return notify("Error", "error") end

        lib.callback('ars-rental:checkMoney', false, function(money)
            if money >= price then
                local alert = lib.alertDialog({
                    header = 'Ars Rental',
                    content = 'Are you sure you want to  continue? \n the total price would be '..price.."$",
                    centered = true,
                    cancel = true
                })
                if alert == "confirm" then
                    spawnRentalCar(car, sp, time)
                end
            else
                notify("You dont have enough money", "error")
            end
        end)
    end
end

function spawnRentalCar(vehModel, spawnPos, time)
    local playerPed = cache.ped

    TriggerServerEvent("ars-rental:removeMoney", price)
    DoScreenFadeOut(500)
    Wait(500)
    
    local model = lib.requestModel(vehModel, 10)
    
    local rentalCar = CreateVehicle(model, spawnPos, true, false)
    
    SetModelAsNoLongerNeeded(model)

    lib.setVehicleProperties(rentalCar, {plate = Config.PlatePrefix})

    Wait(500)
    DoScreenFadeIn(600)
    
    rentedCar = true
    notify("You rented a vehicle", "success")

    

    TaskEnterVehicle(playerPed, rentalCar, -1, -1, 1.0, 1, 0)

    print("test")
    SetTimeout(time, function()
        local rentedVehicle = GetVehiclePedIsUsing(playerPed)

        if IsPedInAnyVehicle(playerPed, true) then
            plate = lib.getVehicleProperties(rentedVehicle).plate
        end

        if IsPedInAnyVehicle(playerPed, true) and string.match(plate, Config.PlatePrefix) then
            
            TaskLeaveVehicle(playerPed, rentedVehicle, 0)
            
            while IsPedInVehicle(playerPed, rentedVehicle, true) do
                Wait(0)
            end
            
            Wait(500)
            
            NetworkFadeOutEntity(rentedVehicle, true, true)
            
            Wait(100)
            
            DeleteEntity(rentedVehicle)
            notify("Vehicle returned to the Ars Rental Time UP", "success")
            rentedCar = false
        else
            if DoesEntityExist(rentalCar) then
                DeleteEntity(rentalCar)
                notify("Vehicle returned to the Ars Rental Time UP", "success")
                rentedCar = false
            else
                notify("Vehicle returned to the Ars Rental Time UP", "success")
                rentedCar = false
            end
        end
    end)
end

function notify(msg, type)
    lib.notify({
        title = 'Ars Rental',
        description = msg,
        type = type
    })
end