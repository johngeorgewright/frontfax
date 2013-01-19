#!/usr/bin/env coffee

program	= require 'commander'
actions	= require './actions'
path    = require 'path'

program.version '0.0.1'

program
	.command('compile:less')
	.description('Compiles less files and watches for any changes')
	.action actions.compile.less 'assets/less', 'assets/css'

program
	.command('compile:js')
	.description('Combines all js files in to one file')
	.option('-b, --beautify', 'Beautifies the output')
	.action actions.compile.js 'assets/js', 'assets/js/main.js'

program
	.command('project:new')
	.description('Creates a new project')
	.usage('<name>')
	.action actions.project.new()

program
	.command('server:start')
	.description('Starts the server')
	.action actions.server.start()

program.parse process.argv

