RegisterNetEvent("ars-rental:removeMoney", function(price)
    exports.ox_inventory:RemoveItem(source, 'money', price)
end)
