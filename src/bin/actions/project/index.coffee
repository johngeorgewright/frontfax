async    = require 'async'
skeleton = require './skeleton'
fs       = require 'fs'

exports.new = ->
	create = (name)->
		pckge = new skeleton.Package
			name   : name
			author : 'Frontfax developer'
			base   : name

		gitignore = new skeleton.GitIgnore
			base : name

		procfile = new skeleton.Procfile
			base : name

		config = new skeleton.Config
			base : name

		async.series [
			(callback)-> pckge.render callback
			(callback)-> gitignore.render callback
			(callback)-> procfile.render callback
			(callback)-> config.render callback
			(callback)->
				console.log """

					Now run:
						cd #{name}
						npm i

					"""
				callback()
		]

	->
		program = arguments[arguments.length-1]

		if arguments.length < 2
			console.log 'A name must be given'
			program.help()

		name = arguments[0]

		if fs.existsSync name
			stat = fs.statSync name
			if stat.isDirectory()
				program.confirm "\"#{name}\" already exists. Do you want to create the project inside of an existing directory?", (ok)->
					process.stdin.destroy()
					if ok
						create name
					else
						process.exit()
			else
				create name
		else
			create name

