io   = require 'socket.io'
path = require 'path'
gaze = require 'gaze'

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

exports.refreshClient = (app)->
	clientCode = ->
		"""
		<script src="/socket.io/socket.io.js"></script>
		<script src="/frontfax/refresh.js"></script>
		"""

	app.get '/frontfax/refresh.js', (req, res)->
		res.sendfile path.join(__dirname, '..', 'public', 'js', 'refresh.js')

	res    = app.response
	writer = res.write

	res.write = (chunk, encoding)->
		html = /html/.test @get('Content-Type')
		if chunk and html
			chunk = chunk.toString encoding
			if chunk.indexOf('</body>') >= 0
				newChunk = chunk.replace '</body>', "#{clientCode()}</body>"
				newChunk = new Buffer newChunk, encoding
				try
					@set 'Content-Length', newChunk.length
					chunk = newChunk
				catch e
					# The response is from a proxy
		writer.call this, chunk, encoding

