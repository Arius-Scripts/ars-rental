function createVehicle(vehicleModel, ...)
    local model = lib.requestModel(vehicleModel)
    local ped = cache.ped
    
    if not model then return end

    local vehicle = CreateVehicle(model, ...)

    SetVehicleNeedsToBeHotwired(vehicle, false)
    NetworkFadeInEntity(vehicle, true)
    SetModelAsNoLongerNeeded(model)
    
    return vehicle
end


function notify(msg, type)
    lib.notify({
        title = 'Ars Rental',
        description = msg,
        type = type
    })
end