socket  = require '../../lib/socket'
request = require 'request'
path    = require 'path'

exports.request = (url)->
	(req, res)->
		requestUrl = url + req.originalUrl
		match      = path.extname(req.path).match /html|js|css$/

		if req.method is 'GET' and match?
			req.headers['accept-encoding'] = ''
			res.header 'proxied', true
			req.pipe request requestUrl, (err, proxyRes, body)->
				body = socket.addClientCode body
				res.type match.toString()
				res.send body

		else
			req.pipe(request requestUrl).pipe res

