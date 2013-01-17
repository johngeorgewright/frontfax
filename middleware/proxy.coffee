httpProxy = require 'http-proxy'
proxy     = new httpProxy.RoutingProxy()

module.exports = (host, port)->
	(req, res)->
		proxy.proxyRequest req, res,
			host : host
			port : port

