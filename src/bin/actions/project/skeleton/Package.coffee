Base = require './Base'

module.exports = class Package extends Base

	filename: ->
		'package.json'

	content: ->
		"""
		{
			"name": "#{@name}",
			"version": "0.0.0",
			"description": "Another frontfax environment",
			"scripts": {
				"start": "nf start"
			},
			"author": "#{@author}",
			"dependencies": {
				"frontfax": "*",
				"foreman": "0.0.23",
				"grunter": "~0.0.1",
				"grunt-contrib-less": "~0.3.2",
				"grunt-contrib-uglify": "~0.1.0"
			}
		}
		"""

