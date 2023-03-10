-- Configuration
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'BeansFL & cmd'
description 'An emergencycallstation script'


-- Files Registration
ui_page 'html/index.html'

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
}

client_scripts {
    'config.lua',
    'client/client.lua',
}

server_scripts {
    

    'config.lua',
    'server/server.lua',
    
}

files {
    'html/index.html', 
    'html/sound/**.*' 
} 