option '-w', '--watch', 'Watch for changes'

task 'build', 'Builds the JavaScript files', (options)->

	async   = require 'async'
	fs      = require 'fs'
	cs      = require 'coffee-script'
	walk    = require 'walk'
	mkdirp  = require 'mkdirp'
	pck     = require './package.json'
	path    = require 'path'
	stalker = require 'stalker'
	project = __dirname
	source  = path.join project, 'src'
	dest    = path.join project, 'build'
	bins    = []

	if pck.bin?
		bins.push file for own key, file of pck.bin

	addShebang = (file, callback=->)->
		async.waterfall [

			(callback)->
				fs.readFile path.join(__dirname, file), callback

			(data, callback)->
				data = data.toString()
				unless data.indexOf('#!') is 0
					data = "#!/usr/bin/env node\n\n#{data}"
					callback null, data
				else
					callback null, false

			(data, callback)->
				if data
					fs.writeFile file, data, callback
				else
					callback()

		], callback

	checkBinaryFiles = (callback=->)->
		async.forEach bins, addShebang, callback

	copyFile = (file, callback=->)->
		destFile = file.replace source, dest
		async.waterfall [

			(callback)->
				fs.readFile file, callback

			(data, callback)->
				console.log "Copying #{file}"
				fs.writeFile destFile, data.toString(), callback

		], (err)->
			callback err, destFile

	destName = (file)->
		destFile  = file.replace source, dest
		destDir   = path.dirname destFile
		destBase  = path.basename destFile, '.coffee'
		destBase += '.js'
		"#{destDir}/#{destBase}"

	compileFile = (file, callback=->)->
		destFile = destName file
		async.waterfall [

			(callback)->
				fs.readFile file, callback

			(data, callback)->
				console.log "Compiling #{file}"
				try
					data = cs.compile data.toString(), bare: true
					callback null, data
				catch e
					callback e.message

			(data, callback)->
				fs.writeFile destFile, data, callback

		], (err)->
			callback err, destFile

	mirrorDirectory = (sourceDir, callback=->)->
		destDir = sourceDir.replace source, dest
		mkdirp destDir, callback

	modifiedFile = (file, callback=->)->
		if path.extname(file) is '.coffee'
			compileFile file, callback
		else
			copyFile file, callback

	removedFile = (file, callback=->)->
		destFile = destName file
		fs.unlink destFile, (err)->
			if err
				callback err
			else
				console.log "Removed #{destFile}"
				callback null, destFile

	if options.watch
		stalker.watch source, (err, file)->

			async.waterfall [

				(callback)-> callback err
				(callback)-> mirrorDirectory path.dirname(file), callback
				(callback)-> modifiedFile file, callback
				(destFile, callback)->
					if file in bins
						addShebang destFile, callback
					else
						callback()

			], (err)->
				console.log err if err

		, (err, file)->

			async.waterfall [

				(callback)-> callback err
				(callback)-> removedFile file, callback
				
			], (err)->
				console.log err if err

	else
		walker = walk.walk 'src'

		# Mirror directories in the destination directory
		walker.on 'directory', (root, stats, next)->
			sourceDir = path.join project, "#{root}/#{stats.name}"
			mirrorDirectory sourceDir, (err)->
				if err
					console.log err
				else
					next()

		# Compile .coffee and just copy all other files
		walker.on 'file', (root, stats, next)->
			sourceFile = path.join project, "#{root}/#{stats.name}"
			modifiedFile sourceFile, (err)->
				if err
					console.log err
				else
					next()

		# Make sure all bin files have a shebang
		walker.on 'end', checkBinaryFiles

