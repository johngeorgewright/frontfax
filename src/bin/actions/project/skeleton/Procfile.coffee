Base = require './Base'
util = require '../../../lib/procfile'
#os   = require 'os'

module.exports = class Procfile extends Base

	filename: ->
		'Procfile'

	content: ->
		content = """
		server: node server
		js: grunt watcher:js --force
		"""
		# Using the os.EOL seems to break NPM's ${APPDATA} variable
		#content += os.EOL + util.coffee() if @coffee
		#content += os.EOL + util.less() if @less
		content += "\n" + util.coffee() if @coffee
		content += "\n" + util.less() if @less
		content

