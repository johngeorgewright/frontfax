http = require 'http'

module.exports = (host, port)->
	(req, res, next)->
		options =
			hostname : host
			port     : port
			path     : req.url
			method   : req.method

		proxyReq = http.request options, (proxyRes)->
			proxyRes.pipe res
			# Make sure that redirects don't forward to production server
			if proxyRes.headers.location?
				proxyRes.headers.location = proxyRes.headers.location.replace "#{host}:#{port}", req.headers.host
			res.writeHead proxyRes.statusCode, proxyRes.headers

		req.pipe proxyReq

