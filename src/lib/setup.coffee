mkdirp = require 'mkdirp'

exports.createDirectories = (dirs, callback)->
	make = (path, done)->
		mkdirp path, (err)->
			callback err if err
			callback null, path

	make dir for dir in dirs

