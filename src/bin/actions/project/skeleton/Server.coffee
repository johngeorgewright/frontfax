Base = require './Base'

module.exports = class Server extends Base

	filename: ->
		'server.js'

	content: ->
		"""
		var server = require('frontfax');
		server.start();
		"""

