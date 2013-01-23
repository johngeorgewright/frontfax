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
				"foreman": "git+https://github.com/johngeorgewright/node-foreman.git#windows"
			}
		}
		"""

