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
			"js": {
				"paths": "/js"
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
			"coffee": {
				"dev": {
					"options": {
						"base": true
					},
					"files": {
						"assets/js/src/*.js": ["assets/coffee/**/*.coffee"]
					}
				}
			},
			"concat": {
				"js": {
					"src": "assets/js/src/**/*.js",
					"dest": "assets/js/main.js"
				}
			},
			"watcher": {
				"coffee": {
					"files": ["assets/coffee/**/*.coffee"],
					"tasks": ["coffee:dev"]
				},
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

