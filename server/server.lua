function SendSOS()
    print("function wurde getriggered")
    local playerdata = ESX.GetPlayerData(source)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
  
    for i = 1, #Config.Jobs, 1 do
        if playerdata.job.name == Config.Jobs[i] then
            local blip = AddBlipForCoord(playerCoords.x, playerCoords.y, playerCoords.z)
            SetBlipSprite(blip, 84)
            SetBlipScale(blip, 1.2)
            SetBlipColour(blip, 1)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("SOS")
            EndTextCommandSetBlipName(blip)
            ShowNotification1()
            PlaySound2()
            SetBlipRoute(blip, true)
            SetBlipRouteColour(blip, 1)
            SetBlipAlpha(blip, 250) 
            SetBlipFlashes(blip, true)
            SetBlipFlashInterval(blip, 400)
            
            CreateThread(function()
                while DoesBlipExist(blip) do
                    SetBlipRouteColour(blip, 1)
                    Wait(150)
                    SetBlipRouteColour(blip, 6)
                    Wait(150)
                    SetBlipRouteColour(blip, 35)
                    Wait(150)
                    SetBlipRouteColour(blip, 6)
                end
            end)
            
            Wait(60 * 1000)
            
            RemoveBlip(blip)
            blip = nil
            break
        end
    end
end


RegisterNetEvent('sendSOS')
AddEventHandler('sendSOS', function()
    SendSOS()
    print("function wird getriggered")
end)
 
