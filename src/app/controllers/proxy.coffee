socket  = require '../../lib/socket'
request = require 'request'
path    = require 'path'

exports.request = (url)->
	(req, res, next)->
		requestUrl = url + req.originalUrl
		extname    = path.extname req.path
		match      = extname.match /html|js|css$/
		html       = extname in ['.html', '']

		res.header 'proxied', true

		if req.method is 'GET' and (match? or html)
			req.headers['Accept-Encoding'] = ''
			req.pipe request requestUrl, (err, proxyRes, body)->
				if err
					next err
				else
					body = socket.addClientCode body if html
					res.type if match then match[0] else 'html'
					res.send body

		else
			req.pipe(request requestUrl).pipe res

