--#--
--Fx info--
--#--
fx_version "cerulean"
game "gta5"
lua54 "yes"
version '1.0.2'


--#--
--Manifest--
--#--
client_scripts {
    "client/functions/utils.lua",
    "client/functions/functions.lua",
    "client/client.lua"
}


server_script { "server/server.lua" }

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua"
}
