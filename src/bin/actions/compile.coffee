stalker = require 'stalker'
mkdirp  = require 'mkdirp'
path    = require 'path'
walk    = require 'walk'
spawn   = require('child_process').spawn

exports.js = (source, dest)->

	combiningJs = no

	(program)->

		process.exit()

		mkdirp path.dirname dest

		stalker.watch source, (err, file)->

			if err
				console.log err

			else unless combiningJs
				combiningJs = yes
				walker      = walk.walk source
				files       = []

				walker.on 'file', (root, stats, next)->
					file = "#{root}/#{stats.name}"
					ext  = path.extname stats.name
					files.push file unless file is dest or ext isnt '.js'
					next()

				walker.on 'end', ->
					console.log "Combining all files from #{source} to #{dest}"
					commands = files
					commands.push '-o', dest
					commands.push '-b' if program.beautify
					uglify = spawn 'uglifyjs', commands
					uglify.stdout.on 'data', (data)-> console.log data.toString()
					uglify.stderr.on 'data', (data)-> console.log data.toString()
					uglify.on 'exit', -> combiningJS = no

exports.less = (source, dest)->

	compilingLess = []

	(program)->
		
		stalker.watch source, (err, file)->

			if err
				console.log err

			else if path.extname(file) is '.less' and file not in compilingLess
				compilingLess.push file

				build     = file.replace source, dest
				basename  = path.basename build, path.extname build
				basename += '.css'
				buildDir  = path.dirname build
				build     = "#{buildDir}/#{basename}"

				console.log "Compiling #{file} to #{build}"
				mkdirp buildDir
				lessc = spawn 'lessc', [file, build]
				lessc.stdout.on 'data', (data)-> console.log data.toString()
				lessc.stderr.on 'data', (data)-> console.log data.toString()
				lessc.on 'exit', -> compilingLess.splice compilingLess.indexOf(file), 1

