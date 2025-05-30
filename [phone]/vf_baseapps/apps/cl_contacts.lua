local App
local ContactsScreen

-- TODO Figure out how to place these in certain spots on the phone screen.

-- Send a notification to the player.
function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

--

-- Send a message to the player.
function sendMessage(msg)
    TriggerEvent('chat:addMessage', {
        args = {msg, },
    })
end

local function Lester_RemoveWanted()
    local player = GetPlayerPed(-1)
    local playerId = PlayerPedId()
    -- if IsPlayerPlaying(player) then
        -- SetPlayerWantedLevel(player, 0, false)
        -- SetPlayerWantedLevelNow(player, false)

    notify("Test")

    -- end
end

local function TeleportToSky()
    local player = GetPlayerPed(-1)
    local playerPos = GetEntityCoords(player)
    local playerX = playerPos.x
    local playerY = playerPos.y
    local playerZ = playerPos.z + 50

    SetEntityCoords(player, playerX, playerY, playerZ, false, false, false, false)
end

local Contacts = {
    -- Create single menu option
    -- { Name = "Lester", Actions = { { Name = "Remove Wanted Level", Handler = Lester_RemoveWanted } } },
    -- Create multiple menu items.
    { Name = "Actions", Actions =
    {
        { Name = "Remove Wanted Level", Handler = Lester_RemoveWanted },
        { Name = "Teleport To Sky", Handler = TeleportToSky }
    }},

    -- Create another menu
    -- { Name = "Test", Actions = { { Name = "Test", Handler = Lester_RemoveWanted } } }
}

AddEventHandler("vf_baseapps:setup", function(phone)
    App = phone.CreateApp(GetLabelText("CELL_0"), 11)
    ContactsScreen = App.CreateListScreen()
    App.SetLauncherScreen(ContactsScreen)

    for _, contact in pairs(Contacts) do
        local contactActionsMenu = App.CreateListScreen()

        ContactsScreen.AddScreenItem(contact.Name, 1, contactActionsMenu)
        
        for _, action in pairs(contact.Actions) do
            contactActionsMenu.AddCallbackItem(action.Name, 0, action.Handler)
        end
    end
end)