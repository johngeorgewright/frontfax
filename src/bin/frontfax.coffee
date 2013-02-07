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
  .usage('<name>')
  .parse(process.argv)

if program.args? and program.args.length > 0
  actions.project.new() program.args[0], program
else
  program.help()


