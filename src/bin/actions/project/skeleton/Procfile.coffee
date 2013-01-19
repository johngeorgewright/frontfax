Base = require './Base'

module.exports = class Procfile extends Base

	filename: ->
		'Procfile'

	content: ->
		"""
		server: node_modules/.bin/frontfax server:start
		less: node_modules/.bin/frontfax compile:less
		js: node_modules/.bin/frontfax compile:js -b
		"""

