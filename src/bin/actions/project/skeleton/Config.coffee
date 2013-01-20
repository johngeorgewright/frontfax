Base = require './Base'

module.exports = class Config extends Base

	filename: ->
		'config/default.json'

	content: ->
		"""
		{
			"base": false,
			"assets": {
				"images": "/r/SysConfig/WebPortal/:project/_files/images",
				"css": "/r/SysConfig/WebPortal/:project/_files/css",
				"js": "/r/SysConfig/WebPortal/:project/_files/js"
			},
			"proxy": {
				"host": "google.com",
				"port": 80
			}
		}
		"""

