path = require 'path'
env  = require 'foreman/lib/envs'

workspaceDefault = path.join __dirname, '..', 'frontfax-workspace'

defaults =
	WORKSPACE       : workspaceDefault
	PRODUCTION_HOST : '172.16.133.43'
	PRODUCTION_PORT : 51161
	LESS_SOURCE     : path.join workspaceDefault, 'assets', 'less'
	CSS_BUILD_DEST  : path.join workspaceDefault, 'build', 'css'
	JS_SOURCE       : path.join workspaceDefault, 'assets', 'js'
	JS_BUILD_DEST   : path.join workspaceDefault, 'build', 'js'
	BOOTSTRAP_PATH  : path.join __dirname, 'node_modules', 'bootstrap'

module.exports = (envFile = path.join(__dirname, '.env'))->
	envs = env.loadEnvs envFile

	{
		get: (name, def)->
			envs[name] ? process.env[name] ? defaults[name] ? def
	}

