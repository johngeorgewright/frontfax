Base = require './Base'

module.exports = class Procfile extends Base

	filename: ->
		'Procfile'

	content: ->
		"""
		server: frontfax server:start
		less: frontfax compile:less -w
		js: frontfax compile:js -b -w
		"""

