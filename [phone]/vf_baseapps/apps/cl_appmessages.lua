local Phone
local App
local MessagesScreen

-- RegisterNetEvent("vf_phone:ReceivePlayerMessage")
-- AddEventHandler("vf_phone:ReceivePlayerMessage", function(playerServer, message)
--     while Phone.GetSignalStrength() == 0 do
--         Wait(1000)
--     end

--     local player = GetPlayerFromServerId(playerServer)

--     local headshotId = RegisterPedheadshot(GetPlayerPed(player))
--     while not IsPedheadshotReady(headshotId) do
--         Wait(0)
--     end

--     local headshotTxd = GetPedheadshotTxdString(headshotId)
--     local playerName = GetPlayerName(player)

--     if not Phone.IsSleepModeOn() then
--         SetNotificationTextEntry("STRING")
--         AddTextComponentString(message)
--         SetNotificationMessage(headshotTxd, headshotTxd, true, 1, "New Message", playerName)
--         DrawNotification(true, true)
--         PlaySound(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default")
--     end

--     local h, m = NetworkGetServerTime()
--     local _MessageDetailScreen = App.CreateCustomScreen(7, message.SenderName)

--     MessagesScreen.AddCustomScreenItem({ h, m, -1, playerName, message }, _MessageDetailScreen)
--     _MessageDetailScreen.AddCustomCallbackItem({ playerName, message, headshotTxd })
-- end)

-- List of label texts for the phone:
-- CELL_1 = Texts
-- CELL_2 = Internet
-- CELL_5 = Email
-- CELL_16 = Settings
-- CELL_13 = BAWSAQ
-- CELL_14 = Page 2 apps?

-- CELL_28 = Trackify
-- CELL_29 = MP Job List

-- TODO Figure out how to make a phone dialer, and add 911 so the player can call the cops to their location.
function SetupNumpad()
    local numpad0 = "CELL_900"
    local numpad1 = "CELL_901"
    local numpad2 = "CELL_902"
    local numpad3 = "CELL_903"
    local numpad4 = "CELL_904"
    local numpad5 = "CELL_905"
    local numpad6 = "CELL_906"
    local numpad7 = "CELL_907"
    local numpad8 = "CELL_908"
    local numpad9 = "CELL_909"

    local numpadAsterisk = "CELL_910"
    local numHash = "CELL_911"
end

local AppIcons = {
    APP_SNAPMATIC = 1,
    APP_MESSAGE = 2,
    APP_EMAIL = 4,
    APP_CONTACTS = 5,
    APP_INTERNET = 5,
    APP_CONTACTS_ADD = 11,
    APP_TODO = 12,
    APP_PLAYERS = 14,
    APP_GAME = 35, -- Game Icon
    

}

AddEventHandler("vf_baseapps:setup", function(phone)
    Phone = phone
    -- App = Phone.CreateApp(GetLabelText("CELL_1"), 4)
    -- App = Phone.CreateApp(GetLabelText("CELL_28"), 4)
    -- MessagesScreen = App.CreateCustomScreen(6)
    -- 2 = Contacts I guess
    -- 8 = Messages sideways
    -- 9 = Messages blank
    -- 11 = Cellphone Number pad, needs setup but I might be able to use this
    -- 13 = Blank screen
    -- 14 = Blank screen - Brown top bar color
    -- 15 = Todo List - Brown top bar color
    -- 18 = Messages normal
    -- 19 = Blank List with bullet
    -- 20 = Yellow notepad like
    -- MessagesScreen = App.CreateCustomScreen(9)
    -- MessagesScreen = App.CreateCustomScreen(15)
    -- MessagesScreen = App.CreateCustomScreen(22)

    -- App.SetLauncherScreen(MessagesScreen)

    -- App = phone.CreateApp(GetLabelText("CELL_35"), 14)
    App = phone.CreateApp(GetLabelText("CELL_15"), AppIcons.APP_TODO)
    TestListScreen = App.CreateListScreen()
    App.SetLauncherScreen(TestListScreen)

    -- TODO Test loop from cl_appplayerlist
    Citizen.CreateThread(function()
        local loopApp = App
        while App == loopApp do -- Destroy this loop (and coroutine) on vf_phone restart
            Wait(1000)
            TestListScreen.ClearItems()
            local testMenu = App.CreateListScreen("Test")
            testMenu.AddScreenItem("Test", 0, testMenu)

            -- TestListScreen.AddCallbackItem("Test")
            TestListScreen.AddCallbackItem(GetLabelText("collision_uy2q01"), 0, function()
                Wait(0) -- Stop from instantly confirming message

                DisplayOnscreenKeyboard(6, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Wait(0)
                end

                if UpdateOnscreenKeyboard() == 1 then
                    local message = GetOnscreenKeyboardResult()
                    SetNotificationTextEntry("STRING")
                    if phone.GetSignalStrength() == 0 then
                        AddTextComponentString("~r~No signal!")
                    elseif #message:gsub("%s+", "") == 0 then
                        AddTextComponentString("~r~Message too short!")
                    else
                        -- TriggerServerEvent("vf_phone:SendPlayerMessage", GetPlayerServerId(i), message)
                        -- AddTextComponentString("~g~Message sent!")
                    end

                    DrawNotification(true, true)
                end
            end)
        end
    end)
end)
