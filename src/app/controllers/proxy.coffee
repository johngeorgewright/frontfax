socket  = require '../../lib/socket'
request = require 'request'
path    = require 'path'

exports.request = (url)->
	(req, res, next)->
		requestUrl = url + req.originalUrl
		extname    = path.extname req.path
		match      = extname.match /html|js|css$/
		html       = /text\/html/i.test(res.get 'content-type') or extname in ['.html', '.aspx', '']

		res.header 'proxied', true

		# TODO Once I figure out how to get the written content
		# from a piped response, we won't need to do any of this
		# and can leave it up to the socket controller.
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

