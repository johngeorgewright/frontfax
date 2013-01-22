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

	addShebang = (file, callback)->
		fs.readFile "#{__dirname}/#{file}", (err, data)->
			if err
				callback err
			else unless data.toString().indexOf('#!') is 0
				data = "#!/usr/bin/env node\n\n#{data.toString()}"
				fs.writeFile file, data, (err)->
					if err
						callback err
					else
						callback null, data
			else
				callback()

	checkBinaryFiles = (callback=->)->
		if pck.bin?
			shebangs = []
			for file in bins
				shebangs.push (callback)-> addShebang file, callback
			async.parallel shebangs, (err, data)->
				console.log err if err
			, callback

	copyFile = (file, callback=->)->
		destFile = file.replace source, dest
		fs.readFile file, (err, data)->
			if err
				callback err
			else
				console.log "Copying #{file}"
				fs.writeFile destFile, data, callback

	destName = (file)->
		destFile  = file.replace source, dest
		destDir   = path.dirname destFile
		destBase  = path.basename destFile, '.coffee'
		destBase += '.js'
		"#{destDir}/#{destBase}"

	compileFile = (file, callback=->)->
		destFile = destName file
		fs.readFile file, (err, data)->
			if err
				callback err
			else
				console.log "Compiling #{file}"
				data = cs.compile data.toString(), bare: true
				fs.writeFile destFile, data, callback

	mirrorDirectory = (sourceDir, callback=->)->
		destDir = sourceDir.replace source, dest
		mkdirp destDir, callback

	modifiedFile = (file, callback=->)->
		if path.extname(file) is '.coffee'
			compileFile file, callback
		else
			copyFile file, callback

	removeDest = (file, callback=->)->
		destFile = destName file
		fs.unlink destFile, (err)->
			if err
				console.log err
			else
				console.log "Removed #{destFile}"
				callback()

	if options.watch
		stalker.watch source, (err, file)->
			if err
				console.log err
			else
				mirrorDirectory path.dirname file, (err)->
					if err
						console.log err
					else
						modifiedFile file, (err)->
							if err
								console.log err
							else
								destFile = destName file
								addShebang destFile if destFile in bins
		, (err, file)->
			if err
				console.log err
			else
				removeDest file

	else
		walker = walk.walk 'src'

		# Mirror directories in the destination directory
		walker.on 'directory', (root, stats, next)->
			sourceDir = path.join project, "#{root}/#{stats.name}"
			mirrorDirectory sourceDir, next

		# Compile .coffee and just copy all other files
		walker.on 'file', (root, stats, next)->
			sourceFile = path.join project, "#{root}/#{stats.name}"
			modifiedFile sourceFile, next

		# Make sure all bin files have a shebang
		walker.on 'end', checkBinaryFiles

