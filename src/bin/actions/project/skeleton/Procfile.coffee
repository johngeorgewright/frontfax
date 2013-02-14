Base = require './Base'

module.exports = class Procfile extends Base

	filename: ->
		'Procfile'

	content: ->
		"""
		server: node server
		coffee: grunter watcher:coffee:dev --force
		less: grunter watcher:less:dev --force
		js: grunter watcher:js:dev
		"""

