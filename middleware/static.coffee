fs   = require 'fs'
url  = require 'url'
send = require 'send'

module.exports = (path, baseURL)->
	(req, res, next)->
		parsedURL = url.parse req.url

		if parsedURL.pathname.indexOf(baseURL) is 0
			filename = parsedURL.pathname.replace baseURL, ''
			sender   = send req, filename

			sender.root path
			sender.on 'error', next
			sender.pipe res

		else
			next()

