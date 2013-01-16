fs   = require 'fs'
path = require 'path'

module.exports = (req, res, next)->
	if req.url.indexOf("#{req.jsURL}/require.min.js") is 0

		assets    = path.join __dirname, '..', 'assets', 'js'
		requirejs = path.join assets, 'require.min.js'
		fin       = path.join assets, 'fin.js'
		output    = ''
		files     = [requirejs, fin]
		done      = []

		rtn = ->
			res.writeHead 200, 'text/javascript'
			res.end output

		loadFile = (filename)->
			fs.readFile filename, (err, data)->
				next err if err
				next "#{filename} doesn not exist" if data is undefined
				output += data.toString()
				done.push filename
				rtn() if files.length is done.length

		loadFile file for file in files

	else
		next()

