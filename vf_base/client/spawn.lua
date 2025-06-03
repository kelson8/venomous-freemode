--[[
            vf_base - Venomous Freemode - base resource
              Copyright (C) 2018-2020  FiveM-Scripts
              Copyright (C) 2025  kelson8

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

firstTick = false
local ShowLoadingScreen = false
local spawnPos = generateSpawn()

-- Change the fade times here
local fadeOutTime = 1500
local fadeInTime = 500

-- Toggle on/off the sky effect like GTA Online, and toggle the loading prompt.
local skySwoopEffect = true

-- Well I guess this is needed, I spawn in invisible without this.
local toggleLoadingPrompt = true

AddEventHandler('onClientGameTypeStart', function()
	exports.spawnmanager:setAutoSpawnCallback(function()
		exports.spawnmanager:spawnPlayer({
			x = spawnPos.x,
			y = spawnPos.y,
			z = spawnPos.z - 1.0,
			model =
			'mp_m_freemode_01'
		})
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
			-- SetEntityVisible(PlayerPedId(), false, 0)
			SetEntityVisible(PlayerPedId(), false, false)
			if skySwoopEffect then

				SwitchToMultiFirstpart(PlayerPedId(), 32, 1)
				Wait(3000)
			end

			if toggleLoadingPrompt then
				showLoadingPrompt("PCARD_JOIN_GAME", 8000)
				Wait(1000)
			end

			-- Where I am not using the database support, I will disable this for now.
			-- TriggerServerEvent("vf_base:GetInventory")
		end

		GetRandomMultiPlayerModel("mp_m_freemode_01")

		for k, v in pairs(Config.weapons) do
			GiveWeaponToPed(PlayerPedId(), v, 500, false, false)
		end

		-- TODO Possibly revert these? I don't want to wait forever when debugging this.
		Wait(3000)

		if skySwoopEffect then
			Wait(1000)

			SwitchToMultiSecondpart(PlayerPedId())
			Wait(5000)
			-- Wait(1000)

		end
		SetEntityVisible(PlayerPedId(), true, false)

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

	local ipls = { 'facelobby', 'farm', 'farmint', 'farm_lod', 'farm_props',
		'des_farmhouse', 'post_hiest_unload', 'v_tunnel_hole',
		'rc12b_default', 'refit_unload' }

	for k, v in pairs(ipls) do
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

				-- Input respawn, TODO Make a config option for this.
				-- PC Keyboard LMB and RT on Xbox controller = 24
				-- Xbox controller A = 21
				-- if IsControlJustPressed(0, 24) then
				-- 	if Config.RespawnOnButton then
				-- end
				-- if IsControlJustPressed(0, 24) or IsControlJustPressed(0, 21) then
				DoScreenFadeOut(fadeOutTime)
				while not IsScreenFadedOut() do
					HideHudAndRadarThisFrame()
					Wait(fadeOutTime)
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

				-- NetworkResurrectLocalPlayer(x, y, z-1.0, 0.0, true, false)
				NetworkResurrectLocalPlayer(x, y, z - 1.0, 0.0, 5000, false)
				ClearPedBloodDamage(playerPed)
				ClearPedWetness(playerPed)
				StopScreenEffect("DeathFailOut")

				SetScaleformMovieAsNoLongerNeeded(deathscale)
				SetScaleformMovieAsNoLongerNeeded(Instructional)

				TriggerServerEvent('vf_ammunation:LoadPlayer')
				Wait(800)
				-- DoScreenFadeIn(500)
				DoScreenFadeIn(fadeInTime)
				locksound = false
				-- end
			else
				if IsControlJustPressed(0, 20) then
					-- ShowHudComponentThisFrame(3)
					ShowHudComponentThisFrame(HudComponent.Cash)
					-- ShowHudComponentThisFrame(4)
					ShowHudComponentThisFrame(HudComponent.MpCash)

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
