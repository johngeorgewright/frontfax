io   = require 'socket.io'
path = require 'path'
gaze = require 'gaze'

exports.refreshServer = (server)->
	ioServer = io.listen server
	ioServer.sockets.on 'connection', (socket)->
		gaze '**/*.*', (err, watcher)->
			@on 'all', (event, filename)->
				switch path.extname filename
					when '.css'
						console.log 'Refreshing your CSS'
						socket.emit 'refreshCSS'
					when '.js', '.html', '.png', '.gif'
						console.log 'Refreshing your page'
						socket.emit 'refreshAll'

exports.refreshClient = ->
	clientCode = (hostname)->
		"""
		<script src="/socket.io/socket.io.js"></script>
		<script src="/frontfax/refresh.js"></script>
		"""

	(req, res, next)->
		res.app.get '/frontfax/refresh.js', (req, res)->
			res.sendfile path.join(__dirname, '..', 'public', 'js', 'refresh.js')

		writer = res.write

		res.write = (chunk, encoding)->
			if chunk
				chunk = chunk.toString encoding
				if chunk.indexOf('</body>') >= 0
					chunk = chunk.replace '</body>', clientCode() + '</body>'
					chunk = new Buffer chunk, encoding
					@set 'Content-Length', chunk.length

			writer.call this, chunk, encoding
		
		next()

