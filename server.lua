
RegisterServerEvent('paint:syncColor', function(netId, r, g, b)
    TriggerClientEvent('paint:applyColor', -1, netId, r, g, b)
end)

RegisterServerEvent('paint:syncChameleon', function(netId, modColor)
    TriggerClientEvent('paint:applyChameleon', -1, netId, modColor)
end)
