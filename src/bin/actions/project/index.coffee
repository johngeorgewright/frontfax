async    = require 'async'
path     = require 'path'
mkdirp   = require 'mkdirp'
skeleton = require './skeleton'
fs       = require 'fs'
{spawn}  = require 'child-proc'

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

# Installs all NPM dependencies
#
# @param callback {Function} OnComplete callback
npmInstall = (callback)->
	install = spawn 'npm', ['i'], stdio: 'inherit'
	install.on 'exit', (code)->
		if code is 0
			callback()
		else
			callback new Error "Cannot install NPM dependencies. Error code #{code}."

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
		], callback
			
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
					callback new Error 'Skipped'

			(creations, callback)->
				try
					process.chdir name
					callback()
				catch e
					callback e

			(callback)->
				npmInstall callback

		], (err)->
			console.log err.message if err

# Adds tech support for things like LESS and CoffeeScript
exports.add = ->

	packageUtil = require '../../lib/package'
	configUtil  = require '../../lib/config'
	procUtil    = require '../../lib/procfile'

	# Adds dependencies to the package.json
	amendPackage = (options, callback)->
		file = path.resolve 'package.json'
		pck  = require file
		packageUtil.addLess pck if options.less
		packageUtil.addCoffee pck if options.coffee
		fs.writeFile file, JSON.stringify(pck, null, 2), callback

	# Adds extra configuration
	amendConfig = (options, callback)->
		file = path.resolve 'config/default.json'
		json = require file
		configUtil.addLess json if options.less
		configUtil.addCoffee json if options.coffee
		fs.writeFile file, JSON.stringify(json, null, 2), callback

	# Adds to the process list
	amendProcfile = (options, callback)->
		file = path.resolve 'Procfile'
		fs.readFile file, (err, data)->
			if err
				callback err
			else
				lines = data.toString().match /[^\n\r]+/g
				lines.push procUtil.less() if options.less and procUtil.less() not in lines
				lines.push procUtil.coffee() if options.coffee and  procUtil.coffee() not in lines
				fs.writeFile file, lines.join("\n"), callback

	# Adds tech to the current project
	add = (options, callback)->
		base = path.resolve '.'
		if options.less or options.coffee
			async.parallel [
				(callback)-> if options.less then createLessAssets(base, callback) else callback()
				(callback)-> if options.coffee then createCoffeeAssets(base, callback) else callback()
				(callback)-> amendPackage options, callback
				(callback)-> amendConfig options, callback
				(callback)-> amendProcfile options, callback
			], callback

	# The return function
	(program)->
		async.series [

			# Is the current directory an NPM project?
			(callback)->
				fs.exists 'package.json', (exists)->
					if exists
						callback()
					else
						callback new Error 'The current directory doesn\'t seem to be a NPM project.'

			# Add the extras
			(callback)->
				add program, callback

			# Install NPM dependencies
			(callback)->
				npmInstall callback

		], (err)->
			console.log "ERROR: #{err.message}" if err

