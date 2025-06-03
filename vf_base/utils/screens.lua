---@diagnostic disable: param-type-mismatch
--[[
            vf_base - Venomous Freemode - base resource
              Copyright (C) 2018-2020  FiveM-Scripts

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program in the file "LICENSE".  If not, see <http://www.gnu.org/licenses/>.
]]

local warningDisplayed
warning = nil
deathscale = nil

-- Notifications
function DisplayNotification(text)
    SetNotificationTextEntry("STRING")
    SetNotificationBackgroundColor(140)
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function DisplayNotificationWithImg(icon, type, sender, title, text, color)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationBackgroundColor(color)
    SetNotificationMessage(icon, icon, true, type, sender, title, text)
    DrawNotification(false, true)
    PlaySoundFrontend(GetSoundId(), "Text_Arrive_Tone", "Phone_SoundSet_Default", true)
end
--

-- Show the loading busy spinner and a message.
function showLoadingPrompt(label, time)
    Citizen.CreateThread(function()
        BeginTextCommandBusyString(tostring(label))
        EndTextCommandBusyString(3)
        Citizen.Wait(time)
        RemoveLoadingPrompt()
    end)
end

function SetButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function SetButton(ControlButton)
    -- N_0xe83a3e3557a56640(ControlButton)
    ScaleformMovieMethodAddParamPlayerNameString(ControlButton)
end

function RequestDeathScaleform()
    local deathform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
    Instructional = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(deathform) do
    	Wait(500)
    end

    return deathform
end

-- Show the wasted screen
function RequestDeathScreen()
	HideHudAndRadarThisFrame()

	if not locksound then
		ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 2.0)
		StartScreenEffect("DeathFailOut", 0, true)

		-- PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
		PlaySoundFrontend(-1, "Bed", "WastedSounds", true)
		deathscale = RequestDeathScaleform()
		locksound = true
	end


    -- TODO Look into making these into functions to be used in a command or in my menu
    -- Death scaleform
	BeginScaleformMovieMethod(deathscale, "SHOW_WASTED_MP_MESSAGE")
    BeginTextCommandScaleformString("STRING")
    AddTextComponentSubstringTextLabel("RESPAWN_W")
    EndTextCommandScaleformString()

    -- Unsure what this one is
    BeginTextCommandScaleformString("AMHB_BYOUDIED")
    EndTextCommandScaleformString()

	PushScaleformMovieFunctionParameterFloat(105.0)
	PushScaleformMovieFunctionParameterBool(true)
	EndScaleformMovieMethod()
    --

	SetScreenDrawPosition(0.00, 0.00)
	DrawScaleformMovieFullscreen(deathscale, 255, 255, 255, 255, 0)
    --

    -- Instructional Buttons

    -- Clear
    BeginScaleformMovieMethod(Instructional, "CLEAR_ALL")
    EndScaleformMovieMethod()
    --

    --
    BeginScaleformMovieMethod(Instructional, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    EndScaleformMovieMethod()
    --

    -- Set the HUD_INPUT27 button
    BeginScaleformMovieMethod(Instructional, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    SetButton(GetControlInstructionalButton(2, 329, true))
    SetButtonMessage(GetLabelText("HUD_INPUT27"))
    EndScaleformMovieMethod()
    --

    -- Draw the instruction buttons
    BeginScaleformMovieMethod(Instructional, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()
    --

    -- Set the color
    BeginScaleformMovieMethod(Instructional, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    EndScaleformMovieMethod()
    --

    -- Draw the other scaleform.
    DrawScaleformMovieFullscreen(Instructional, 255, 255, 255, 255, 0)

	return deathscale
end

-- Setup the player xp bar
function SetPlayerScores(currentRankLimit, nextRankLimit, playersPreviousXP, playersCurrentXP, rank)
    if not HasHudScaleformLoaded(19) then
        RequestHudScaleform(19)
        Wait(200)
    end

    BeginScaleformMovieMethodHudComponent(19, "SET_RANK_SCORES")
    PushScaleformMovieFunctionParameterInt(currentRankLimit)
    PushScaleformMovieFunctionParameterInt(nextRankLimit)
    PushScaleformMovieFunctionParameterInt(playersPreviousXP)
    PushScaleformMovieFunctionParameterInt(playersCurrentXP)
    PushScaleformMovieFunctionParameterInt(rank)
    EndScaleformMovieMethodReturn()
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsPlayerSwitchInProgress() or hidehud then
            HideHudAndRadarThisFrame()
        end

        if HasHudScaleformLoaded(19) then
            BeginScaleformMovieMethodHudComponent(19, "OVERRIDE_ANIMATION_SPEED")
            PushScaleformMovieFunctionParameterInt(2000)
            EndScaleformMovieMethodReturn()

            BeginScaleformMovieMethodHudComponent(19, "SET_COLOUR")
            PushScaleformMovieFunctionParameterInt(116)
            PushScaleformMovieFunctionParameterInt(123)
            EndScaleformMovieMethodReturn()
        end
    end
end)