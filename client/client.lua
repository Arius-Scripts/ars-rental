local positions = {}
local rentedCar = false



CreateThread(function()
    for k,v in pairs(Config.Positions) do

        blip = AddBlipForCoord(v.pos)
        SetBlipSprite(blip, 778)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 54)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Ars Rental")
        EndTextCommandSetBlipName(blip)

        for i = 1, #k, 1 do
            positions[i] = lib.points.new({
                coords = v.pos,
                distance = 3,
                eleId = k,
                onEnter = function(self)
                    lib.showTextUI('[E] - Interact', {position = "top-center",icon = 'hand',style = {borderRadius = 0,backgroundColor = '#3a4d57',color = 'white'}})
                end,
                onExit = function()
                    lib.hideTextUI()
                end,
                nearby = function(self)
                    DrawMarker(21, self.coords.x, self.coords.y, self.coords.z - 1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.6,0.6,0.6,58, 77, 87, 200, false, true, 2, nil, nil, false)
                    if self.currentDistance < 2 and not IsEntityDead(cache.ped) and IsControlJustPressed(0, 38) then
                        rentalMenu(k)
                    end
                end
            })
        end
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
                        TriggerServerEvent("ars-rental:removeMoney", price)
                        DoScreenFadeOut(500)
                        Wait(500)
                        
                        lib.requestModel(car, 10)
                        
                        local rentalCar = CreateVehicle(car, sp)
                        
                        SetModelAsNoLongerNeeded(car)

                        lib.setVehicleProperties(rentalCar, {plate = Config.PlatePrefix})

                        Wait(500)
                        DoScreenFadeIn(600)
                        
                        rentedCar = true
                        notify("You rented a vehicle", "success")

                        SetTimeout(time, function()
                            rentedVehicle = GetVehiclePedIsUsing(cache.ped)

                            if IsPedInAnyVehicle(cache.ped, true) then
                                plate = lib.getVehicleProperties(rentedVehicle).plate
                            end

                            if IsPedInAnyVehicle(cache.ped, true) and string.match(plate, Config.PlatePrefix) then
                                
                                TaskLeaveVehicle(cache.ped, rentedVehicle, 0)
                                
                                while IsPedInVehicle(cache.ped, rentedVehicle, true) do
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
                else
                    notify("You dont have enough money", "error")
                end
            end)
        end
    end




    function notify(msg, type)
        lib.notify({
            title = 'Ars Rental',
            description = msg,
            type = type
        })
    end

    RegisterNetEvent("ars-rental:notify", function(msg, type)
        notify(msg, type)
    end)
end)

