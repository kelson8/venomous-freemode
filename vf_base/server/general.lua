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

if Config.enableTextChat then
	StopResource('chat')
else
	StartResource('chat')
end

StopResource('scoreboard')

RegisterServerEvent('vf_base:LoadPlayer')
AddEventHandler('vf_base:LoadPlayer', function()
	local src = source
	Player:Find(src, function(data)
		if data then
			local bank = data.bank
			local cash = data.cash
			local rank = data.rank
			local xp = data.xp

			 TriggerClientEvent('vf_base:DisplayCashValue', src, cash)
			 TriggerClientEvent('vf_base:DisplayBankValue', src, bank)
		end
	end)
end)

-- I disabled this message, I may reuse it later or not.
-- It always says this is out of date.
-- PerformHttpRequest("https://raw.githubusercontent.com/FiveM-Scripts/venomous-freemode/master/vf_base/__resource.lua", function(errorCode, result, headers)
--     local version = GetResourceMetadata(GetCurrentResourceName(), 'resource_version', 0)

--     if string.find(tostring(result), version) == nil then
--         print("\n\r[Venomous Freemode] The version on this server is not up to date. Please update now.\n\r")
--     end
-- end, "GET", "", "")

RegisterServerEvent("vf_base:KickRes")
AddEventHandler("vf_base:KickRes", function(reason)
	DropPlayer(source, tostring(reason))
end)

function GetInventoryItems(license)
	local params = {['license'] = license}
	exports.ghmattimysql:scalar("SELECT license FROM venomous_inventory WHERE license = @license", params, function(result)
		if result then
			exports.ghmattimysql:execute("SELECT *, COUNT(*) AS total FROM venomous_inventory WHERE license = @license GROUP BY item", params, function(data)
				return data
			end)
		end
	end)
end

function AddInventoryItem(src, item)
	local data = {["license"] = license, ["item"] = tostring(item)}

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		local params = {['license'] = user.license, ["item"] = tostring(item)}
		exports.ghmattimysql:execute("INSERT INTO venomous_inventory (`license`, `item`) VALUES (@license, @item)", params, function() 
			exports.ghmattimysql:execute("SELECT *, COUNT(*) AS total FROM venomous_inventory WHERE license = @license  GROUP BY item", params, function(data)
				TriggerClientEvent('vf_base:refresh_inventory', src, data)
			end)
	    end)
	end)
end

RegisterServerEvent('vf_inventory:additem')
AddEventHandler('vf_inventory:additem', function(item)
	local src = source

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		local params = {['license'] = user.license, ["item"] = tostring(item)}
		exports.ghmattimysql:execute("INSERT INTO venomous_inventory (`license`, `item`) VALUES (@license, @item)", params, function() end)
	end)
end)

RegisterServerEvent('vf_base:GetInventory')
AddEventHandler('vf_base:GetInventory', function()
	local src = source

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		local params = {['license'] = user.license}
		exports.ghmattimysql:scalar("SELECT license FROM venomous_inventory WHERE license = @license", params, function(result)
			if not result then
				print('No inventory items are found for ' .. GetPlayerName(src))
			else
				exports.ghmattimysql:execute("SELECT *, COUNT(*) AS total FROM venomous_inventory WHERE license = @license  GROUP BY item", params, function(data)
					TriggerClientEvent('vf_base:refresh_inventory', src, data)
				end)
			end
		end)
	end)
end)

RegisterServerEvent('vf_base:UpdateInventory')
AddEventHandler('vf_base:UpdateInventory', function(item)
	local src = source
	local stockItem = item

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		local params = {['license'] = user.license, ['item'] = item}

		exports.ghmattimysql:scalar("SELECT license, item FROM venomous_inventory WHERE license = @license and item = @item", params, function(result)
			if result then
				exports.ghmattimysql:execute("DELETE FROM venomous_inventory WHERE license = @license and item = @item LIMIT 1", params, function(queryR)
					if queryR then
						exports.ghmattimysql:execute("SELECT *, COUNT(*) AS total FROM venomous_inventory WHERE license = @license  GROUP BY item", params, function(data)
							TriggerClientEvent('vf_base:refresh_inventory', src, data)
						end)
					end
				end)
			end
		end)
	end)
end)