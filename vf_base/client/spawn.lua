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

-- This is what does the skyswoop effect for when you join in.
-- Like in online, it will bring the camera in the sky with the sound effect.
-- And it will bring you back down, also you get a random multiplayer character with a random outfit.

-- TODO Make this effect configureable.

firstTick = false
local ShowLoadingScreen = false
local spawnPos = generateSpawn()

AddEventHandler('onClientGameTypeStart', function()
	exports.spawnmanager:setAutoSpawnCallback(function()
		exports.spawnmanager:spawnPlayer({x = spawnPos.x, y = spawnPos.y, z = spawnPos.z-1.0, model = 'mp_m_freemode_01'})
    end)

    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

Citizen.CreateThread(function()
	if not firstTick then
		while not NetworkIsGameInProgress() and IsPlayerPlaying(PlayerId()) do
			Wait(800)
		end

		if not IsPlayerSwitchInProgress() then
			SetEntityVisible(PlayerPedId(), false, 0)
        	SwitchToMultiFirstpart(PlayerPedId(), 32, 1)
			Wait(3000)

			showLoadingPrompt("PCARD_JOIN_GAME", 8000)
			Wait(1000)

			-- Where I am not using the database support, I will disable this for now.
			-- TriggerServerEvent("vf_base:GetInventory")
		end

		GetRandomMultiPlayerModel("mp_m_freemode_01")

		for k,v in pairs(Config.weapons) do
			GiveWeaponToPed(PlayerPedId(), v, 500, false, false)
		end

		Wait(5000)

		SwitchToMultiSecondpart(PlayerPedId())
		SetEntityVisible(PlayerPedId(), true, 0)
		Wait(5000)

		TriggerServerEvent('vf_base:LoadPlayer')
		exports.spawnmanager:setAutoSpawn(false)
		Wait(2000)
		SetPlayerScores(1, 2000, 1, 1000, 1)		
		TriggerServerEvent('vf_ammunation:LoadPlayer')
		firstTick = true

		playerID = PlayerId()
		playerName = GetPlayerName(playerID)
		playerPed = PlayerPedId()
	end

	local ipls = {'facelobby', 'farm', 'farmint', 'farm_lod', 'farm_props', 
	              'des_farmhouse', 'post_hiest_unload', 'v_tunnel_hole',
	              'rc12b_default', 'refit_unload'}

	for k,v in pairs(ipls) do
		if not IsIplActive(v) then
			RequestIpl(v)
		end
	end

	while true do
		-- Wait(10)
		Wait(0)
		if firstTick then
			if IsPedDead then
				deathscale = RequestDeathScreen()
				if IsControlJustPressed(0, 24) then
					DoScreenFadeOut(500)
					while not IsScreenFadedOut() do
						HideHudAndRadarThisFrame()
						Wait(500)
					end

					local Px, Py, Pz = table.unpack(GetEntityCoords(playerPed))
					success, vec3 = GetSafeCoordForPed(Px, Py, Pz, false, 28)
					heading = 0

					if success then
						x, y, z = table.unpack(vec3)
					else
						local temp = generateSpawn()
						x, y, z = temp.x, temp.y, temp.z
					end

					NetworkResurrectLocalPlayer(x, y, z-1.0, 0.0, true, false)
					ClearPedBloodDamage(playerPed)
					ClearPedWetness(playerPed)
					StopScreenEffect("DeathFailOut")

					SetScaleformMovieAsNoLongerNeeded(deathscale)
					SetScaleformMovieAsNoLongerNeeded(Instructional)

					TriggerServerEvent('vf_ammunation:LoadPlayer')
					Wait(800)
					DoScreenFadeIn(500)
					locksound = false
				end
			else
				if IsControlJustPressed(0, 20) then
					ShowHudComponentThisFrame(3)
					ShowHudComponentThisFrame(4)

					if not HasHudScaleformLoaded(19) then
						RequestHudScaleform(19)
						Wait(10)
					end

					BeginScaleformMovieMethodHudComponent(19, "SHOW")
					EndScaleformMovieMethodReturn()
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(300)
		if firstTick then
			playerPed = PlayerPedId()
			if GetEntityHealth(playerPed) <= 0 then
				IsPedDead = true
			else
				IsPedDead = false
			end
		end
	end
end)
