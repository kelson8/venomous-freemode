fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'FiveM-Scripts'
description 'FiveM Venomous Freemode ammunation'

dependency 'NativeUI'

client_scripts {
    '@NativeUI/NativeUI.lua',
    'weapons.lua',
    'client.lua'
}

server_script 'server.lua'