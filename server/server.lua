RegisterServerEvent('serverSOS', function()
    local target = GetEntityCoords(GetPlayerPed(source))

    if Config.Framework == "ESX" then
        local playerList = ESX.GetPlayers()
        for i = 1, #playerList, 1 do
            local player = ESX.GetPlayerFromId(playerList[i])
            for j = 1, #Config.Jobs, 1 do 
                if player.job.name == Config.Jobs[j] then  
                    TriggerClientEvent('clientSOS', player.source, target.x, target.y, target.z)
                    break
                end 
            end
        end
    elseif Config.Framework == "QB" then
        local playerList = QBCore.Functions.GetPlayers()
        for i = 1, #playerList, 1 do
            local player = QBCore.Functions.GetPlayer(playerList[i])
            for j = 1, #Config.Jobs, 1 do
                if player ~= nil and player.job ~= nil and player.job.name == Config.Jobs[j] then 
                    TriggerClientEvent('clientSOS', player.source, target.x, target.y, target.z)
                    break
                end 
            end
        end
    else
        print("Invalid framework specified in Config!")
        return
    end
end)
