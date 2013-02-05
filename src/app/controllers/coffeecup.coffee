cc   = require 'coffeecup'
fs   = require 'fs'
path = require 'path'

exports.render = (sourceDir)->

	(req, res, next)->
		
		source  = req.path
		extname = path.extname source

		unless extname in ['', '.html']
			next()

		else
			source  = path.basename source, extname
			source  = 'index' if source is ''
			source += '.coffee'
			source  = path.join sourceDir, source

			if fs.existsSync source
				data = fs.readFileSync source
				res.type 'html'
				res.send cc.render data.toString()
			else
				next()

