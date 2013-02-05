jade	= require 'jade'
fs		= require 'fs'
path	= require 'path'
async = require 'async'

exports.render = (sourceDir)->
	
	(req, res, next)->

		source	= req.path
		extname = path.extname source

		unless extname in ['', '.html']
			next()

		else
			source	= path.basename source, extname
			source	= 'index' if source is ''
			source += '.jade'
			source	= path.join sourceDir, source

			# Lets not go async
			if fs.existsSync source
				data = fs.readFileSync source
				compiler = jade.compile data.toString(), pretty:true, filename:source
				res.type 'html'
				res.send compiler()
			else
				next()

			###
			async.waterfall [

				(callback)->
					fs.exists source, (exists)-> callback null, exists

				(exists, callback)->
					if exists
						fs.readFile source, callback
					else
						callback null, false

				(data, callback)->
					if data is false
						callback(null, false)
					else
						compiler = jade.compile data.toString(), pretty: true, filename: source
						callback null, compiler()

			], (err, output)->

				if err
					next err
				else if output is false
					next()
				else
					res.type 'html'
					res.send output
			###

