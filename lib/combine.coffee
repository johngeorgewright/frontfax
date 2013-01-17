fs   = require 'fs'
path = require 'path'

exports.dir = (dir, extname, callback)->
	output = ''
	done   = []

	fs.readdir dir, (err, files)->
		callback err if err

		filesToSend = []

		for file in files
			filesToSend.push file if path.extname(file) is extname

		callback() unless filesToSend.length > 0

		for file in filesToSend
			fs.readFile "#{dir}/#{file}", (err, data)->
				callback err if err
				output += data.toString()
				done.push file
				callback null, output if done.length is filesToSend.length

