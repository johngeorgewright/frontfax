Base = require './Base'
pack = require '../../../../../package.json'

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
				"start": "nf start",
				"prepublish": "grunter prepublish --force"
			},
			"author": "#{@author}",
			"dependencies": {
				"frontfax": "#{pack.version}",
				"config": "0.4.18",
				"foreman": "0.0.23",
				"grunter": "~0.0.1",
				"grunt-contrib-less": "~0.3.2",
				"grunt-contrib-coffee": "~0.3.2"
			}
		}
		"""

