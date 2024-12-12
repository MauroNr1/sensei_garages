fx_version 'cerulean'
game 'gta5'

lua54 'yes'

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
    'modules/*.lua'
}

client_scripts {
    'client/main.lua',
    'client/store.lua',
    'client/retrieve.lua',
    'client/debug.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
