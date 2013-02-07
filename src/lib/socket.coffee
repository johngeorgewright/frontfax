exports.clientCode = clientCode = ->
	"""
	<script src="/socket.io/socket.io.js"></script>
	<script src="/frontfax/refresh.js"></script>
	"""

exports.addClientCode = addClientCode = (html, encoding)->
	if html.indexOf('</body>') >= 0
		html = html.replace '</body>', "#{clientCode()}</body>"
	html = new Buffer html, encoding
	html

