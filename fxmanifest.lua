fx_version   'cerulean'
lua54        'yes'
games        { 'gta5' }

name         't1-lift'
author       'enesrght'
version      '1.0.0'
description  'Elevators Script.'

--[[ Manifest ]]--
dependencies {
	'/server:5848',
    '/onesync',
}

shared_scripts {
    'sh_*.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client/cl_*.lua'
}
