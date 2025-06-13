fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'FiveM-Scripts'
description 'FiveM Venomous Freemode Interaction menu'

dependencies {'ghmattimysql', 'NativeUI', 'vf_base'}

client_scripts {
    '@NativeUI/NativeUI.lua',
    'config/costs.lua',
    'config/vehicles.lua',
    'vehicles.lua',
	'client.lua'
}

server_script 'server.lua'