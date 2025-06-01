fx_version 'adamant'
game 'gta5'
author 'FiveM-Scripts'

-- Original author of theses scripts:
-- https://github.com/FiveM-Scripts/venomous-freemode

resource_type 'gametype' { name = 'venomous-freemode' }
resource_version '1.1.3'

-- dependencies {'ghmattimysql'}

-- kelson8-
-- I added a enums.lua to this, for useful stuff like explosion ids, 
-- controller button ids, hud components, and parachute states.
-- Instead of needing to use the numbers for these, you can just use the tables in enums.lua. 



client_scripts {
    'config/freemode.lua',
    'config/spawn.lua',
    'config/vehicles.lua',
    'utils/player.lua',
    'utils/screens.lua',
    'utils/vehicles.lua',
    'client/spawn.lua',
    -- Enums from my C++ tests.
    'config/enums.lua'
}

export 'GetInventory'
server_export 'AddInventoryItem'
server_export 'GetInventoryItems'

server_scripts {
    'config/freemode.lua',
    -- 'server/database.lua',
    'server/player.lua',
    'server/general.lua'
}