httpProxy = require 'http-proxy'

exports.request = (options)->
	proxy = new httpProxy.RoutingProxy()
	path  = ''
	
	(req, res)->
		options.buffer = req.proxyBuffer if req.proxyBuffer?
		proxy.proxyRequest req, res, options

exports.buffer = ->
	(req, res, next)->
		req.proxyBuffer = httpProxy.buffer req
		next()

