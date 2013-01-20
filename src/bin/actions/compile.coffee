fs      = require 'fs'
stalker = require 'stalker'
mkdirp  = require 'mkdirp'
path    = require 'path'
walk    = require 'walk'
spawn   = require('child_process').spawn
bin     = path.join __dirname, '..', '..', '..', 'node_modules', '.bin'

exports.js = (source, dest)->

	combiningJs = no

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
					commands = files
					commands.push '-o', dest
					commands.push '-b' if program.beautify
					uglify = spawn "#{bin}/uglifyjs", commands
					uglify.stdout.on 'data', (data)-> console.log data.toString()
					uglify.stderr.on 'data', (data)-> console.log data.toString()
					uglify.on 'exit', -> combiningJS = no

	(program)->
		mkdirp path.dirname(dest), ->
			if program.watch
				stalker.watch source, (err, file)->
					if err
						console.log err
					else
						compile program
			else
				compile program

exports.less = (source, dest)->

	compilingLess = []

	compile = (file)->
		if path.extname(file) is '.less' and file not in compilingLess
			compilingLess.push file

			build     = file.replace source, dest
			basename  = path.basename build, path.extname build
			basename += '.css'
			buildDir  = path.dirname build
			build     = "#{buildDir}/#{basename}"

			console.log "Compiling #{file}"
			mkdirp buildDir, (err)->
				if err
					console.log err
				else
					lessc = spawn "#{bin}/lessc", [file, build]
					lessc.stdout.on 'data', (data)-> console.log data.toString()
					lessc.stderr.on 'data', (data)-> console.log data.toString()
					lessc.on 'exit', (code)->
						if code is 0
							console.log "Created #{build}"
							compilingLess.splice compilingLess.indexOf(file), 1

	(program)->
		mkdirp source, ->
			if program.watch
				stalker.watch source, (err, file)->
					if err
						console.log err
					else
						compile file
			else
				walker = walk.walk source
				walker.on 'file', (root, stats, next)->
					compile "#{root}/#{stats.name}"
					next()

