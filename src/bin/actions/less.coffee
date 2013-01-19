stalker  = require 'stalker'
mkdirp   = require 'mkdirp'
path     = require 'path'
spawn    = require('child_process').spawn

module.exports = (source, dest)->

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

