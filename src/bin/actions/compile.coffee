fs      = require 'fs'
stalker = require 'stalker'
mkdirp  = require 'mkdirp'
path    = require 'path'
walk    = require 'walk'
exec    = require('child_process').exec
bin     = path.join __dirname, '..', '..', '..', 'node_modules', '.bin'

exports.js = (source, dest, callback(msg)=->console.log(msg))->

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
					callback "Combining all files from #{source} to #{dest}"
					result = UglifyJS.minify files,
						output:
							beautify: program.beautify ? false
					fs.writeFile dest, result.code, (err)->
						callback err if err
						combiningJs = no
				else
					fs.unlink dest, (err)->
						if err
							callback err
						else
							callback "Removed #{dest}"

	(program)->
		modify = (err, file)->
			if err
				callback err
			else
				compile program, callback

		mkdirp path.dirname(dest), ->
			if program.watch
				stalker.watch source, modify, modify
			else
				compile program

exports.less = (source, dest, callback(msg)=->console.logmsg))->

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
			callback "Compiling #{file}"
			mkdirp path.dirname(build), (err)->
				if err
					callback err
				else
					exec "#{bin}/lessc #{file} #{build}", (error, stdout, stderr)->
						if error
							callback error.message
						else if stderr
							callback stderr
						else
							callback stdout
							callback "Created #{build}"
						compilingLess.splice compilingLess.indexOf(file), 1

	modify = (err, file)->
		if err
			callback err
		else
			compile file

	remove = (err, file)->
		if err
			callback err
		else
			file = cssName file
			fs.unlink file, (err)->
				if err
					callback err
				else
					callback "Removed #{file}"

	(program)->

		mkdirp source, ->
			if program.watch
				stalker.watch source, modify, remove
			else
				walker = walk.walk source
				walker.on 'file', (root, stats, next)->
					compile "#{root}/#{stats.name}"
					next()

