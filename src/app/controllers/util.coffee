exports.extractPort = ->
	(req, res, next)->
		reg   = /:(\d+)/
		match = req.headers.host.match reg

		if match
			req.port = parseInt match[1]
		else
			req.port = 80

		next()

exports.replaceInResponse = (app, replacements)->
	res    = app.response
	writer = res.write

	res.write = (chunk, encoding)->
		isText = /text\//.test @get('Content-Type')
		if chunk and isText
			newChunk = chunk.toString encoding
			for own key, value of replacements
				newChunk = newChunk.replace key, value
			try
				@set 'Content-Length', newChunk.length
				chunk = newChunk
			catch e
				# The response is from a proxy
		writer.call this, chunk, encoding

