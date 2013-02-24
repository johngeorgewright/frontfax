util = require './util'

exports.clientCode = clientCode = ->
	"""
	<script src="/socket.io/socket.io.js"></script>
	<script src="/frontfax/refresh.js"></script>
	"""

exports.addClientCode = addClientCode = (html, encoding)->
	clientCodeRegExp = new RegExp util.escapeRegExp clientCode()
	if html.indexOf('</body>') >= 0 and not clientCodeRegExp.test html
		html = html.replace '</body>', "#{clientCode()}</body>"
	html = new Buffer html, encoding
	html

