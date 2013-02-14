path = require 'path'

exports.renderer = ->
	(req, res, next)->
		source  = req.path
		source  = source.substr(1) if source[0] is '/'
		extname = path.extname source

		unless extname in ['', '.html']
			next()

		else
			basename = path.basename source, extname
			basename = 'index' if basename is ''
			source   = "#{path.dirname source}/#{basename}"

			console.log source

			res.render source, (err, str)->
				if err
					if err.message is "Failed to lookup view \"#{source}\""
						next()
					else
						next err
				else
					res.send str

