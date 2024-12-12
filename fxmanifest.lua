fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

name 'sensei_garages'
author 'MauroNr1'
version '1.0.0'
repository 'https://github.com/MauroNr1/sensei_garages'
description 'A garage system for ox_core using ox_lib'

dependencies {
    '/server:7290',
    '/onesync',
    'ox_core',
    'ox_lib',
    'oxmysql',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@ox_core/lib/init.lua'
}

files {
    'data/*.lua',
    'client/utils.lua',
    'locales/*.json'
}

client_scripts {
    'client/main.lua',
    'client/store.lua',
    'client/retrieve.lua',
    'client/creator.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ox_libs {
    'locale'
}