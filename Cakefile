task 'start', 'Starts the server', ->
	app = require './app'
	app.start()

option '-e', '--env [FILE]', 'use FILE to load environment'
task 'build:js', 'Compiles all JavaScript requirements into one file', (options)->
	path   = require 'path'
	spawn  = require('child_process').spawn
	config = require('./config') options.env

	builder = spawn path.join('node_modules', '.bin', 'r.js'), [
		'-o',
		"baseUrl=#{path.join config.get('WORKSPACE'), 'assets', 'js'}",
		"paths.bootstrap/dropdown=#{path.join __dirname, 'node_modules', 'bootstrap', 'js', 'bootstrap-dropdown'}",
		'name=main',
		'out=main.js'
	]

	builder.stdout.on 'data', (data)-> console.log data.toString()
	builder.stderr.on 'data', (data)-> console.log data.toString()
	builder.on 'exit', (code)-> console.log "exited with code #{code}"

