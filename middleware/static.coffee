fs    = require 'fs'
url   = require 'url'
send  = require 'send'
utils = require 'connect/lib/utils'

module.exports = (path, baseURL)->
	(req, res, next)->
		next() unless req.method in ['GET', 'HEAD']

		pathname = url.parse(req.url).pathname

		if pathname.indexOf(baseURL) is 0
			filename = pathname.replace baseURL, ''
			sender   = send req, filename
			pause    = utils.pause req

			resume = ->
				next()
				pause.resume()

			error = (err)->
				if err.status is 404
					resume()
				else
					next err

			sender.root path
			sender.on 'error', error
			sender.on 'directory', resume
			sender.pipe res

		else
			next()

