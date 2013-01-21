fs      = require 'fs'
stalker = require 'stalker'
mkdirp  = require 'mkdirp'
path    = require 'path'
walk    = require 'walk'
exec    = require('child_process').exec
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
					fs.unlink dest, (err)->
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

	compilingLess = []

	cssName = (lessName)->
		name      = lessName.replace source, dest
		basename  = path.basename name, path.extname name
		basename += '.css'
		buildDir  = path.dirname name
		"#{buildDir}/#{basename}"

	compile = (file)->
		if path.extname(file) is '.less' and file not in compilingLess
			compilingLess.push file
			build = cssName file
			console.log "Compiling #{file}"
			mkdirp path.dirname(build), (err)->
				if err
					console.log err
				else
					exec "#{bin}/lessc #{file} #{build}", (error, stdout, stderr)->
						if error
							console.log error.message
						else if stderr
							console.log stderr
						else
							console.log stdout
							console.log "Created #{build}"
						compilingLess.splice compilingLess.indexOf(file), 1

	modify = (err, file)->
		if err
			console.log err
		else
			compile file

	remove = (err, file)->
		if err
			console.log err
		else
			file = cssName file
			fs.unlink file, (err)->
				if err
					console.log err
				else
					console.log "Removed #{file}"

	(program)->

		mkdirp source, ->
			if program.watch
				stalker.watch source, modify, remove
			else
				walker = walk.walk source
				walker.on 'file', (root, stats, next)->
					compile "#{root}/#{stats.name}"
					next()

