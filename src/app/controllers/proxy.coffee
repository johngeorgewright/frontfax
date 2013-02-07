socket  = require '../../lib/socket'
request = require 'request'
path    = require 'path'

exports.request = (url)->
	(req, res)->
		requestUrl = url + req.originalUrl

		if req.method is 'GET' and path.extname(req.path) in ['.html', '']
			req.pipe request requestUrl, (err, proxyRes, body)->
				body = socket.addClientCode body
				res.type 'text/html'
				res.send body

		else
			req.pipe(request requestUrl).pipe res

