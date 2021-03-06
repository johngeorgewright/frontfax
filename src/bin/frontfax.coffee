#!/usr/bin/env coffee

program	= require 'commander'
actions	= require './actions'
path    = require 'path'
pck     = require '../../package.json'

program.version pck.version ? '0.0.0'

program
	.command('start')
	.description('Starts the server')
	.action actions.server.start()

program
	.command('new <name>')
	.description('Creates a new frontfax project')
	.option('--less', 'Adds LESS support')
	.option('--coffee', 'Adds CoffeeScript support')
	.action actions.project.new()

program
	.command('add')
	.description('Adds extra support (like LESS and CoffeeScript) to an existing Frontfax project')
	.option('--less', 'Adds LESS suport')
	.option('--coffee', 'Adds CoffeeScript support')
	.action actions.project.add()

program.parse process.argv

