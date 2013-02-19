Base = require './Base'

module.exports = class Procfile extends Base

	filename: ->
		'Procfile'

	content: ->
		"""
		server: node server
		coffee: grunt watcher:coffee --force
		less: grunt watcher:less --force
		js: grunt watcher:js --force
		"""

