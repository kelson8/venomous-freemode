fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'FiveM-Scripts'
description 'FiveM Venomous Freemode weed buying'

dependencies {'NativeUI', 'vf_base'}

client_scripts {
    '@NativeUI/NativeUI.lua',
    'client.lua'
}

server_script "server.lua"