#!/usr/bin/env coffee

program	= require 'commander'
actions	= require './actions'
path    = require 'path'
pck     = require '../../package.json'

program.version pck.version ? '0.0.0'

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

