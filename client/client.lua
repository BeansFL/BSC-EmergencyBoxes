local callboxProps = {} -- Table to store all callbox props

-- Function to spawn a callbox at a specific coordinate
function spawnCallbox(x, y, z, heading)
  local modelHash = GetHashKey('prop_sign_road_callbox')
  if not HasModelLoaded(modelHash) then
    RequestModel(modelHash, cb)
    while not HasModelLoaded(modelHash) do
      Wait(0)  
    end 
  end
  local callboxProp = CreateObject(modelHash, x, y, z, true, true, false)
  SetEntityHeading(callboxProp, heading) 
  FreezeEntityPosition(callboxProp, true) 
 
  -- Add blip for the spawn point
  local blip = AddBlipForCoord(x, y, z)
  SetBlipSprite(blip, 526) -- 2 is the blip sprite for a callbox 
  SetBlipDisplay(blip, 2) -- 2 is the display ID for blips on the radar and map 
  SetBlipScale(blip, 0.8) -- Set blip size 
  SetBlipColour(blip, 47) -- Set blip color to orange
  SetBlipAsShortRange(blip, true) -- Set blip to only show on close range
  BeginTextCommandSetBlipName("STRING") 
  AddTextComponentString(Translation.BlipName) -- set blip name
  EndTextCommandSetBlipName(blip)
 
  table.insert(callboxProps, callboxProp)
end  

-- Function to delete all callbox props 
function deleteCallboxProps()
  for i, callboxProp in ipairs(callboxProps) do
    DeleteObject(callboxProp)
  end
  callboxProps = {} 
end



-- recode

CreateThread(function()
    local playerPed = PlayerPedId()
    for i, spawnPoint in ipairs(Config.spawnPoints) do 
      spawnCallbox(spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.heading)
      TaskTurnPedToFaceCoord(playerPed, spawnPoint.x, spawnPoint.y, spawnPoint.z, 0) 
    end
    local sleep = 1
    while true do
        for k,v in pairs(Config.spawnPoints) do
            if #(GetEntityCoords(PlayerPedId()) - vector3(v.x, v.y, v.z)) < 2.0 then
                sleep = 1
                ShowHelpNotification()
                if IsControlJustPressed(0, 38) then
                  ShowNotification2()
                  print("E pressed")
                    FreezeEntityPosition(playerPed, true) -- Freeze player position
                    PlaySound()
                    local count = 1
                    while count < 300 do 
                        Wait(1)
                        count = count + 1
                        DisablePlayerFiring(playerPed, true) 
                        FreezeEntityPosition(playerPed, true) -- Freeze player position
                    end
                    FreezeEntityPosition(playerPed, true) -- Freeze player position
                    TaskPlayAnim(PlayerPedId(), 'anim@cellphone@in_car@ps', 'cellphone_call_listen_base', 1.0, 1.0, -1, 50, 0, false, false, false)
                    Wait(5000) 
                    ClearPedTasks(PlayerPedId()) 
                    FreezeEntityPosition(playerPed, false) -- Unfreeze player position
                    DisablePlayerFiring(PlayerPedId(), false)  
                    TriggerServerEvent('serverSOS')
                else
                    sleep = 1
                end
            end
        end
        Wait(sleep)
    end
end)

-- Delete all callbox props when the script restarts
AddEventHandler('onResourceStop', function(resource) 
  if GetCurrentResourceName() == resource then
    deleteCallboxProps()
  end 
end) 

-- debug function
logging = function(code, ...)
    if Config.Debug then
        local script = "[^2"..GetCurrentResourceName().."^0]"
        print(string.format(script.." %s", code), ...)
    end
end 

function PlaySound(source)
  local message = { PayloadType = {"SOS"}, Payload = source}
  SendNUIMessage(message) 
end

function PlaySound2(source) 
  local message = { PayloadType = {"SOS2"}, Payload = source}
  SendNUIMessage(message) 
end 

local blip = nil

RegisterNetEvent('clientSOS')
AddEventHandler('clientSOS', function(x, y, z)
    blip = AddBlipForCoord(x, y, z) 
    PlaySound2() -- pass in the source argument
    ShowNotification1(text)
    SetBlipSprite(blip, 4)
    SetBlipScale(blip, 0.4)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("SOS")
    EndTextCommandSetBlipName(blip) 
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1) 
    SetBlipAlpha(blip, 250) 
    SetBlipFlashes(blip, true)
    removeBlip()    
end)  

function removeBlip()
  print("Removing blip in " .. Config.BlipTime .. " seconds.")
  Wait(Config.BlipTime * 1000) 
  if blip ~= nil then
    RemoveBlip(blip)
    print("Blip removed.")
    blip = nil
  end
end



