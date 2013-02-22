Base = require './Base'

module.exports = class Procfile extends Base

	filename: ->
		'Procfile'

	content: ->
		content = """
		server: node server
		js: grunt watcher:js --force
		"""
		content += "\ncoffee: grunt watcher:coffee --force" if @coffee
		content += "\nless: grunt watcher:less --force" if @less
		content

