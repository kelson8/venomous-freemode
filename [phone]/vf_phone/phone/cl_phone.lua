--[[
            vf_phone
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

Phone = {
    Visible = false,
    Theme = GetResourceKvpInt("vf_phone_theme"),
    Wallpaper = GetResourceKvpInt("vf_phone_wallpaper"),
    SleepMode = false,
    SignalStrength = 0,
    InApp = false
}

if Phone.Theme == 0 then
    Phone.Theme = 5
end
if Phone.Wallpaper == 0 then
    Phone.Wallpaper = 11
end

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if Phone.Visible then
            
            SetPauseMenuActive(false)
            SetMobilePhonePosition(58.0, -21.0 - Phone.VisibleAnimProgress, -60.0)
            SetMobilePhoneRotation(-90.0, Phone.VisibleAnimProgress * 4.0, 0.0)

            if Phone.VisibleAnimProgress > 0 then
                Phone.VisibleAnimProgress = Phone.VisibleAnimProgress - 2
            end

            -- Set the titlebar theme to have the clock hours and minutes.
            local h, m = GetClockHours(), GetClockMinutes()
            BeginScaleformMovieMethod(Phone.Scaleform, "SET_TITLEBAR_TIME")
            ScaleformMovieMethodAddParamInt(h)
            ScaleformMovieMethodAddParamInt(m)
            EndScaleformMovieMethod()

            -- Set the sleep mode if toggled
            BeginScaleformMovieMethod(Phone.Scaleform, "SET_SLEEP_MODE")
            ScaleformMovieMethodAddParamBool(Phone.SleepMode)
            EndScaleformMovieMethod()

            -- Set the theme of the phone
            BeginScaleformMovieMethod(Phone.Scaleform, "SET_THEME")
            ScaleformMovieMethodAddParamInt(Phone.Theme)
            EndScaleformMovieMethod()

            -- Set the background image of the phone
            BeginScaleformMovieMethod(Phone.Scaleform, "SET_BACKGROUND_IMAGE")
            ScaleformMovieMethodAddParamInt(Phone.Wallpaper)
            EndScaleformMovieMethod()
            --

            local playerCoords = GetEntityCoords(PlayerPedId())
            local zone = GetZoneAtCoords(playerCoords.x, playerCoords.y, playerCoords.z)

            -- Set the phone signal strength
            Phone.SignalStrength = 5 - GetZoneScumminess(zone)

            BeginScaleformMovieMethod(Phone.Scaleform, "SET_SIGNAL_STRENGTH")
            ScaleformMovieMethodAddParamInt(Phone.SignalStrength)
            EndScaleformMovieMethod()
            --

            local renderID = GetMobilePhoneRenderId()
			SetTextRenderId(renderId)
			DrawScaleformMovie(Phone.Scaleform, 0.0998, 0.1775, 0.1983, 0.364, 255, 255, 255, 255);
            SetTextRenderId(1)

            -- Set the phone scaleform and load it here
        elseif IsControlJustPressed(3, 27) then -- INPUT_PHONE (arrow up / mmb)
            PlaySoundFrontend(-1, "Pull_Out", "Phone_SoundSet_Default")
            Phone.Scaleform = RequestScaleformMovie("CELLPHONE_IFRUIT")
            while not HasScaleformMovieLoaded(Phone.Scaleform) do
                Wait(0)
            end
            
            -- Set phone to visible, set the position and scale, then create the phone.
            Phone.VisibleAnimProgress = 21
            Phone.Visible = true
            SetMobilePhonePosition()
            SetMobilePhoneScale(285.0)
            CreateMobilePhone()
        end
    end
end)

function Phone.Kill()
    Apps.Kill()
    SetScaleformMovieAsNoLongerNeeded(Phone.Scaleform)
    Phone.Scaleform = nil
    Phone.Visible = false
    DestroyMobilePhone()

    -- Prevent esc from immediately opening the pause menu
    while IsControlPressed(3, 177) do
        Wait(0)
        SetPauseMenuActive(false)
    end
end