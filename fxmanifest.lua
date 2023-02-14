fx_version 'cerulean'

game 'gta5'

author 'byK3#7147'
description 'ESX based CITIZEN / EINREISE / IMMIGRATION SCRIPT by byK3#7147'
version '1.0.0'


shared_script '@es_extended/imports.lua'

client_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server.lua',
}


