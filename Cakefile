task 'build', 'Builds the JavaScript files', ->

	async   = require 'async'
	fs      = require 'fs'
	cs      = require 'coffee-script'
	exec    = require('child_process').exec
	walk    = require 'walk'
	mkdirp  = require 'mkdirp'
	pck     = require './package.json'
	path    = require 'path'
	project = __dirname
	source  = path.join project, 'src'
	dest    = path.join project, 'build'

	addShebang = (file, callback)->
		fs.readFile "#{__dirname}/#{file}", (err, data)->
			if err
				callback err
			else if data.toString().indexOf('#!') is 0
				data = "#!/usr/bin/env node\n\n#{data.toString()}"
				fs.writeFile file, data, (err)->
					if err
						callback err
					else
						callback null, data
			else
				callback()

	walker = walk.walk 'src'

	# Mirror directories in the destination directory
	walker.on 'directory', (root, stats, next)->
		sourceDir = path.join project, "#{root}/#{stats.name}"
		destDir   = sourceDir.replace source, dest
		mkdirp destDir, next

	# Compile .coffee and just copy all other files
	walker.on 'file', (root, stats, next)->
		sourceFile = path.join project, "#{root}/#{stats.name}"
		destFile   = sourceFile.replace source, dest
		
		unless path.extname(sourceFile) is '.coffee'
			fs.readFile sourceFile, (err, data)->
				if err
					next err
				else
					console.log "Copying #{sourceFile}"
					fs.writeFile destFile, data, next

		else
			destDir   = path.dirname destFile
			destBase  = path.basename destFile, '.coffee'
			destBase += '.js'
			destFile  = "#{destDir}/#{destBase}"

			fs.readFile sourceFile, (err, data)->
				if err
					next err
				else
					console.log "Compiling #{sourceFile}"
					data = cs.compile data.toString(), bare: true
					fs.writeFile destFile, data, next

	# Make sure all bin files have a shebang
	walker.on 'end', ->
		if pck.bin?
			shebangs = []
			for own name, file of pck.bin
				shebangs.push (callback)-> addShebang file, callback
			async.parallel shebangs, (err, data)->
				console.log err if err

