io     = require 'socket.io'
path   = require 'path'
gaze   = require 'gaze'
socket = require '../../lib/socket'

exports.refreshServer = (server)->
	ioServer = io.listen server, 'log level': 2
	ioServer.sockets.on 'connection', (socket)->

		gaze '**/*.css', (err, watcher)->
			unless err
				@on 'all', (event, filename)->
					console.log 'Refreshing your CSS'
					socket.emit 'refreshCSS'

		gaze ['assets/**/*.js', 'static/**/*.*', 'images/**.*'], (err, watcher)->
			unless err
				@on 'all', (event, filename)->
					console.log 'Refreshing your page'
					socket.emit 'refreshAll'

injection = (method)->
	(chunk, encoding)->
		html = /html/.test @get('Content-Type')
		if chunk and html
			chunk = chunk.toString encoding
			if chunk.indexOf('</body>') >= 0
				newChunk = socket.addClientCode chunk, encoding
				try
					@set 'Content-Length', newChunk.length
					chunk = newChunk
				catch e
					# The response is from a proxy
		method.call @, chunk, encoding

exports.refreshClient = (app)->
	app.get '/frontfax/refresh.js', (req, res)->
		res.sendfile path.join(__dirname, '..', 'public', 'js', 'refresh.js')

	res       = app.response
	res.end   = injection res.end
	res.write = injection res.write

