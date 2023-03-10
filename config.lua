Config = {}

Config.Debug = true

Config.spawnPoints = {
    { x = 2630.7864, y = 3077.9456, z = 46.5250, heading = 315.1406 },
    { x = 2825.7617, y = 3420.0850, z = 54.5926, heading = 340.0},
    { x = 2903.8450, y = 4151.8145, z = 49.2500, heading = 380.0}   
}

Translation = {
    BlipName = "SOS CALLBOX",
    HelpNotify = "Press ~INPUT_CONTEXT~ to interact with the callbox",
    Notification = "You called the police!",
    DispatchNotification = "SOS WAS PRESSED; EMERGENCY REQUIRED. GPS WAS SET"
}

Config.Jobs = { 
    "police",
    "doa", 
    "sheriff",
    "doj",
    "ambulance" 
} 

-- Notification settings
function ShowHelpNotification(msg)
    ESX.ShowHelpNotification(Translation.HelpNotify)
end
 
function ShowNotification1(text)
    ESX.ShowNotification(Translation.DispatchNotification,  5000, "info") 
end 

function ShowNotification2(text)
    ESX.ShowNotification(Translation.Notification, 5000, "info")
end 