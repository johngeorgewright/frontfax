Base = require './Base'

module.exports = class Config extends Base

	filename: ->
		'config/default.json'

	content: ->
		"""
		{
			"base": false,
			"assets": {
				"images": "/SysConfig/WebPortal/:project/_files/images",
				"css": "/SysConfig/WebPortal/:project/_files/css",
				"js": "/SysConfig/WebPortal/:project/_files/js"
			},
			"proxy": {
				"host": "google.com",
				"port": 80
			}
		}
		"""

