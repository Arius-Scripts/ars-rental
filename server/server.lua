RegisterNetEvent("ars-rental:removeMoney", function(data)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - vector3(data.coords.xyz))

    if distance > 1 then return print(source .. " probably modder") end

    exports.ox_inventory:RemoveItem(source, 'money', data.price)
end)

lib.versionCheck('Arius-Development/ars-rental')
