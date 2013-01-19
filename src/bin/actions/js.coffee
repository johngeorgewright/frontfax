stalker = require 'stalker'
mkdirp  = require 'mkdirp'
path    = require 'path'
walk    = require 'walk'
spawn   = require('child_process').spawn

module.exports = (source, dest)->

	combiningJs = no

	(program)->

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

