fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'FiveM-Scripts'
description 'FiveM Venomous Freemode phone'

client_scripts {
    "phone/cl_phone.lua",
    "phone/app/cl_app.lua",
    "phone/app/api/cl_api_app.lua",
    "phone/app/api/cl_api_screen.lua",
    "phone/app/api/cl_api_item.lua",
    "phone/app/api/cl_api.lua",
    "phone/app/cl_appmain.lua",
    "phone/app/cl_appsettings.lua"
}

dependencies {
    "vf_utils"
}