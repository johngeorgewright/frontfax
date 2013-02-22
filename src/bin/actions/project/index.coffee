async    = require 'async'
path     = require 'path'
mkdirp   = require 'mkdirp'
skeleton = require './skeleton'
fs       = require 'fs'

# Returns the asset directory relative to a
# given 'base'
#
# @param base {String} The base directory
# @return String
assetsDir = (base)->
	path.resolve base, 'assets'

# Creates all the required asset directories
# used in a basic project
#
# @param base {String} The base directory
# @param callback {Function} A callback function to call once everything have been completed
createAssets = (base, callback)->
	assets    = assetsDir base
	js        = path.join assets, 'js', 'src'
	css       = path.join assets, 'css'
	images    = path.join assets, 'images'
	stat      = path.resolve base, 'static'
	async.forEach [js, css, images, stat], mkdirp, callback

# Creates all asset directories and files
# for a project that's using LESS.
#
# @param base {String} The base directory
# @param callback {Function} OnComplete callback function
createLessAssets = (base, callback)->
	assets = assetsDir base
	less   = path.join assets, 'less'
	async.series [
		(callback)-> mkdirp less, callback
		(callback)-> fs.writeFile path.join(less, 'main.less'), '', callback
	], callback

# Creates all asset directories for a project
# using CoffeeScript.
#
# @param base {String} The base directory
# @param callback {Function} OnComplete callback function
createCoffeeAssets = (base, callback)->
	coffee = path.join assetsDir(base), 'coffee'
	mkdirp coffee, callback

# Commander action callback for creating a new
# project.
exports.new = ->
	
	# Creates the project workspace.
	#
	# @param name {String} The name of the project
	# @param options {Object} A key/value object of options
	# @param calback {Function} OnComplete callback
	create = (name, options, callback=->)->
		pckge = new skeleton.Package
			name   : name
			author : 'Frontfax developer'
			coffee : options.coffee
			less   : options.less
			base   : name

		gitignore = new skeleton.GitIgnore
			base : name

		procfile = new skeleton.Procfile
			coffee : options.coffee
			less   : options.less
			base   : name

		config = new skeleton.Config
			coffee : options.coffee
			less   : options.less
			base   : name

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
			(callback)-> if options.less then createLessAssets(name, callback) else callback()
			(callback)-> if options.coffee then createCoffeeAssets(name, callback) else callback()
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
				
	# This is the return function
	(name, program)->
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
					create name, program, callback
				else
					callback()

		], (err)->
			console.log err if err

