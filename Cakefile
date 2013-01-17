task 'start', 'Starts the server', ->
	app = require './app'
	app.start()

option '-e', '--env [FILE]', 'use FILE to load environment'
option '-P', '--project [PROJECT]', 'use PROJECT when building files'
task 'build:js', 'Compiles all JavaScript requirements into one file', (options)->
	throw new Error 'The project name is required' if not options.project

	path        = require 'path'
	config      = require('./config') options.env
	combine     = require './lib/combine'
	fs          = require 'fs'
	projectPath = path.join config.get('WORKSPACE'), options.project
	source      = path.join projectPath, 'assets', 'js'
	dest        = path.join projectPath, 'build', 'js', 'main.js'

	combine.dir source, '.js', (err, data)->
		throw new Error err if err
		fs.writeFile dest, data, (err)->
			throw new Error err if err
			console.log dest

task 'setup:workspace', 'Creates all required directories in your workspace', (options)->
	throw new Error 'The project name is required' if not options.project

	path        = require 'path'
	config      = require('./config') options.env
	setup       = require './lib/setup'
	projectPath = path.join config.get('WORKSPACE'), options.project
	assets      = path.join projectPath, 'assets'
	build       = path.join projectPath, 'build'
	jsDir       = path.join assets, 'js'
	jsDest      = path.join build, 'js'
	lessDir     = path.join assets, 'less'
	cssDir      = path.join build, 'css'
	dirs        = [lessDir, cssDir, jsDir, jsDest]

	setup.createDirectories dirs, (err, dir)->
		throw new Error err if err
		console.log " + #{dir}"

