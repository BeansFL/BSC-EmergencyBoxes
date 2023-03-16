local callboxProps = {} -- Table to store all callbox props

-- Function to spawn a callbox at a specific coordinate
function spawnCallbox(x, y, z, heading)
  local modelHash = GetHashKey('prop_sign_road_callbox')
  if not HasModelLoaded(modelHash) then
    ESX.Streaming.RequestModel(modelHash, cb)
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
  SetBlipColour(blip, 47) -- Set blip color to blue
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

-- Main loop 
CreateThread(function()
  local playerPed = PlayerPedId()

  for i, spawnPoint in ipairs(Config.spawnPoints) do 
    spawnCallbox(spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.heading)
    TaskTurnPedToFaceCoord(playerPed, spawnPoint.x, spawnPoint.y, spawnPoint.z, 0) 
  end

  while true do 
    Wait(0)
    local playerCoords = GetEntityCoords(playerPed)
    ESX.Streaming.RequestAnimDict("anim@cellphone@in_car@ps", cb)  
    ESX.Streaming.RequestAnimDict("anim@amb@trailer@touch_screen@", cb) 

    -- Check if player is close to any callbox
    for i, callboxProp in ipairs(callboxProps) do
      local callboxCoords = GetEntityCoords(callboxProp)  
      local distance = #(playerCoords.xy - callboxCoords.xy)

      if distance < 2.0 then
        -- Show help notification and check if player presses E 
        ShowHelpNotification()
        if IsControlJustPressed(0, 38) then  
          FreezeEntityPosition(playerPed, true) -- Freeze player position
          PlaySound()
          ShowNotification2() 

          local count = 1

          while count < 300 do 
            Wait(1) 
            count = count + 1
            print(count)
            DisablePlayerFiring(playerPed, true) 
            FreezeEntityPosition(playerPed, true) -- Freeze player position
          end
 
          FreezeEntityPosition(playerPed, true) -- Freeze player position

          TaskPlayAnim(PlayerPedId(), 'anim@cellphone@in_car@ps', 'cellphone_call_listen_base', 1.0, 1.0, -1, 50, 0, false, false, false)

          Wait(5000) 

          ClearPedTasks(PlayerPedId()) 

          FreezeEntityPosition(playerPed, false) -- Unfreeze player position

          DisablePlayerFiring(PlayerPedId(), false)  

          TriggerEvent('sendSOS')


        end     
      end   
    end    
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
        log.logging(script, code, ...)
    end
end

 
 

RegisterNetEvent('sendSOS')
AddEventHandler('sendSOS', function()
    TriggerServerEvent('sendSOS')
    print("function wird getriggered")
end)
 

 
function PlaySound(source)
  local message = { PayloadType = {"SOS"}, Payload = source}
  SendNUIMessage(message) 
end

function PlaySound2(source) 
  local message = { PayloadType = {"SOS2"}, Payload = source}
  SendNUIMessage(message) 
end 
