Base = require './Base'

module.exports = class Procfile extends Base

	filename: ->
		'Procfile'

	content: ->
		"""
		server: frontfax start
		less: grunter watcher:less:dev --force
		js: grunter watcher:js:dev
		"""

