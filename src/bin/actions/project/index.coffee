async    = require 'async'
path     = require 'path'
mkdirp   = require 'mkdirp'
skeleton = require './skeleton'
fs       = require 'fs'

assetsDir = (base)->
	assetsDir = path.resolve base, 'assets'

createAssets = (base, callback)->
	assets    = assetsDir base
	js        = path.join assets, 'js', 'src'
	css       = path.join assets, 'css'
	images    = path.join assets, 'images'
	stat      = path.resolve base, 'static'
	async.forEach [coffee, less, js, css, images, stat], mkdirp, callback

createLessAssets = (base, callback)->
	assets = assetsDir base
	less   = path.join assets, 'less'
	async.series [
		(callback)-> mkdirp less, callback
		(callback)-> fs.writeFile path.join(less, 'main.less'), '', callback
	], callback

createCoffeeAssets = (base, callback)->
	coffee = path.join assetsDir(base), 'coffee'
	mkdirp coffee, callback

exports.new = ->
	create = (name, callback=->)->
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

		start = new skeleton.Start
			base : name

		grunt = new skeleton.Grunt
			base : name

		server = new skeleton.Server
			base : name

		async.parallel [
			(callback)-> pckge.render callback
			(callback)-> gitignore.render callback
			(callback)-> procfile.render callback
			(callback)-> config.render callback
			(callback)-> createAssets name, callback
			(callback)-> start.render callback
			(callback)-> grunt.render callback
			(callback)-> server.render callback
		], (err)->
			if err
				callback err
			else
				console.log """

					Now run:
						cd #{name}
						npm i

					"""
				callback()

	->
		program = arguments[arguments.length-1]

		if arguments.length < 2
			console.log 'A name must be given'
			program.help()

		name = arguments[0]

		async.waterfall [

			# Does a file or directory exist with the same name?
			(callback)->
				fs.exists name, (exists)-> callback null, exists

			# Fetch the file/directory's stats
			(exists, callback)->
				if exists
					fs.stat name, callback
				else
					callback null, false

			# Confirmation from user if it's a directory
			(stats, callback)->
				if stats and stats.isDirectory()
					program.confirm "\"#{name}\" already exists. Do you want to create the project inside of an existing directory?", (ok)->
						callback null, ok
						process.stdin.destroy()
				else
					callback null, yes

			# Proceed with creation?
			(ok, callback)->
				if ok
					create name, callback
				else
					callback()

		], (err)->
			console.log err if err

