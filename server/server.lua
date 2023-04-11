RegisterServerEvent('serverSOS')
AddEventHandler('serverSOS', function()
    local player = nil
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)

    if Config.Framework == "ESX" then
        player = ESX.GetPlayerFromId(source)
    elseif Config.Framework == "QB" then
        player = QBCore.Functions.GetPlayer(source)
    else
        print("Invalid framework specified in Config!")
        return
    end

    for i = 1, #Config.Jobs, 1 do
        if player.job.name == Config.Jobs[i] then 
            TriggerClientEvent('clientSOS', -1, playerCoords.x, playerCoords.y, playerCoords.z)
            break
        end 
    end 
end)  
 