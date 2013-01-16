task 'start', 'Starts the server', ->
	app = require './app'
	app.start()

option '-e', '--env [FILE]', 'use FILE to load environment'
option '-P', '--project [PROJECT]', 'use PROJECT when building files'
task 'build:js', 'Compiles all JavaScript requirements into one file', (options)->
	throw new Error 'The project name is required' if not options.project

	path        = require 'path'
	spawn       = require('child_process').spawn
	config      = require('./config') options.env
	projectPath = path.join config.get('WORKSPACE'), options.project

	builder = spawn path.join('node_modules', '.bin', 'r.js'), [
		'-o',
		"baseUrl=#{path.join projectPath, 'assets', 'js'}",
		"paths.bootstrap/dropdown=#{path.join __dirname, 'node_modules', 'bootstrap', 'js', 'bootstrap-dropdown'}",
		'name=main',
		"out=#{path.join projectPath, 'build', 'js', 'main.js'}"
	]

	builder.stdout.on 'data', (data)-> console.log data.toString()
	builder.stderr.on 'data', (data)-> console.log data.toString()
	builder.on 'exit', (code)-> console.log "exited with code #{code}"

