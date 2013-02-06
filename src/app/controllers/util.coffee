exports.extractPort = ->
	(req, res, next)->
		reg   = /:(\d+)/
		match = req.headers.host.match reg

		if match
			req.port = parseInt match[1]
		else
			req.port = 80

		next()

