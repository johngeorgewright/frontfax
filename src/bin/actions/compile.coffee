fs      = require 'fs'
stalker = require 'stalker'
mkdirp  = require 'mkdirp'
path    = require 'path'
walk    = require 'walk'
async   = require 'async'
less    = require 'less'
bin     = path.join __dirname, '..', '..', '..', 'node_modules', '.bin'

exports.js = (source, dest)->

	combiningJs = no
	UglifyJS    = require 'uglify-js'

	compile = (program)->
		unless combiningJs
			combiningJs = yes
			walker      = walk.walk source
			files       = []

			walker.on 'file', (root, stats, next)->
				file = "#{root}/#{stats.name}"
				ext  = path.extname stats.name
				files.push file unless file is dest or ext isnt '.js'
				next()

			walker.on 'end', ->
				if files.length > 0
					console.log "Combining all files from #{source} to #{dest}"
					result = UglifyJS.minify files,
						output:
							beautify: program.beautify ? false
					fs.writeFile dest, result.code, (err)->
						console.log err if err
						combiningJs = no
				else
					async.waterfall [
						(callback)-> fs.exists dest, (exists)-> callback null, exists
						(exists, callback)->
							if exists
								fs.unlink dest, callback
							else
								callback null
					], (err)->
						if err
							console.log err
						else
							console.log "Removed #{dest}"

	(program)->
		modify = (err, file)->
			if err
				console.log err
			else
				compile program

		mkdirp path.dirname(dest), ->
			if program.watch
				stalker.watch source, modify, modify
			else
				compile program

exports.less = (source, dest)->

	source        = path.resolve source
	dest          = path.resolve dest
	compilingLess = []

	cssName = (lessName)->
		name      = lessName.replace source, dest
		basename  = path.basename name, path.extname name
		basename += '.css'
		buildDir  = path.dirname name
		"#{buildDir}/#{basename}"

	compile = (err, file, callback=->)->
		return callback() unless path.extname(file) is '.less' and file not in compilingLess

		compilingLess.push file
		build = cssName file
		console.log "Compiling #{file} to #{build}"

		async.waterfall [

			(callback)->       callback err
			(callback)->       mkdirp path.dirname(build), (err)-> callback err
			(callback)->       fs.readFile file, callback
			(data, callback)-> less.render data.toString(), callback
			(css, callback)->  fs.writeFile build, css, callback
			
		], (err)->
			console.log err if err
			compilingLess.splice compilingLess.indexOf(file), 1
			callback err

	remove = (err, file, callback=->)->
		return callback() unless path.extname(file) is '.less'

		build = cssName file
		console.log "Removing #{build}"

		async.waterfall [

			(callback)-> callback err
			(callback)-> fs.exists build, (exists)-> callback null, exists
			(exists, callback)->
				if exists
					fs.unlink build, callback
				else
					callback()
			
		], (err)->
			console.log err if err
			callback err
		
	(program)->

		mkdirp source, (err)->
			if err
				console.log err
			else if program.watch
				stalker.watch source, compile, remove
			else
				walker = walk.walk source
				walker.on 'file', (root, stats, next)->
					compile null, "#{root}/#{stats.name}", next

