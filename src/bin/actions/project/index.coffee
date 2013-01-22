async    = require 'async'
path     = require 'path'
mkdirp   = require 'mkdirp'
skeleton = require './skeleton'
fs       = require 'fs'

exports.new = ->
	createAssets = (base, callback)->
		assetsDir = path.resolve base, 'assets'
		less      = path.join assetsDir, 'less'
		js        = path.join assetsDir, 'js'
		css       = path.join assetsDir, 'css'
		images    = path.join assetsDir, 'images'
		stat      = path.resolve base, 'static'

		async.forEach [less, js, css, images, stat], mkdirp, callback

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

		async.parallel [
			(callback)-> pckge.render callback
			(callback)-> gitignore.render callback
			(callback)-> procfile.render callback
			(callback)-> config.render callback
			(callback)-> createAssets name, callback
		], (err)->
			if err
				console.log err
			else
				console.log """

					Now run:
						cd #{name}
						npm i

					"""

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

