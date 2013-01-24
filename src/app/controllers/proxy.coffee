request = require 'request'

exports.request = (url)->
	(req, res)->
		req.pipe(request url + req.originalUrl).pipe res

