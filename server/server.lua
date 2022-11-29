ESX = exports["es_extended"]:getSharedObject() 




lib.callback.register('ars-rental:checkMoney', function(source, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    money = xPlayer.getAccount('money').money
    return money
end)

RegisterNetEvent("ars-rental:removeMoney", function(price)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeAccountMoney('money', price)
end)
