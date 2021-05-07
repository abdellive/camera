fx_version 'adamant'

game 'gta5'

version '1.0'



client_scripts {
    'maincl.lua',
    'config.lua',
  }
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'mainser.lua'
}

