Base = require './Base'

module.exports = class Config extends Base

	filename: ->
		'config/default.json'

	content: ->
		"""
		{
			"base": false,
			"images": {
				"paths": "/images"
			},
			"css": {
				"paths": "/stylesheets"
			},
			"less": {
				"dev": {
					"options": {
						"paths": ["assets/less"]
					},
					"files": {
						"assets/css/main.css": "assets/less/main.less"
					}
				},
				"prepublish": {
					"options": {
						"paths": "<config:less.dev.options.paths>",
						"compress": true
					},
					"files": "<config:less.dev.files>"
				}
			},
			"js": {
				"paths": "/js"
			},
			"concat": {
				"js": {
					"src": "assets/js/src/**/*.js",
					"dest": "assets/js/main.js"
				}
			},
			"watcher": {
				"less": {
					"files": ["assets/less/**/*.less"],
					"tasks": ["less:dev"]
				},
				"js": {
					"files": "<config:concat.js.src>",
					"tasks": ["concat:js"]
				}
			},
			"proxy": false
		}
		"""

