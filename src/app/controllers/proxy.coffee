socket  = require '../../lib/socket'
request = require 'request'
path    = require 'path'

exports.request = (url)->
	(req, res)->
		requestUrl = url + req.originalUrl
		match      = path.extname(req.path).match /html|js|css$/
		html       = path.extname(req.path).match /html$/

		res.header 'proxied', true

		if req.method is 'GET' and match?
			req.headers['accept-encoding'] = ''
			req.pipe request requestUrl, (err, proxyRes, body)->
				if html?
					body = socket.addClientCode body
					res.type match.toString()
				res.send body

		else
			req.pipe(request requestUrl).pipe res

