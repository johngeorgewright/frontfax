Base = require './Base'

module.exports = class Procfile extends Base

	filename: ->
		'Procfile'

	content: ->
		"""
		server: frontfax server:start
		less: grunter watch:less:dev --force
		js: grunter watch:js:dev
		"""

