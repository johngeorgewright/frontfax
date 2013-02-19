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
						"paths": "<%= less.dev.options.paths %>",
						"compress": true
					},
					"files": "<%= less.dev.files %>"
				}
			},
			"coffee": {
				"options": {
					"base": true
				},
				"files": {
					"expand": true,
					"cwd": "assets/coffee",
					"src": ["**/*.coffee"],
					"dest": "assets/js/src/",
					"ext": ".js"
				}
			},
			"concat": {
				"files": {
					"src": "assets/js/src/**/*.js",
					"dest": "assets/js/main.js"
				}
			},
			"uglify": {
				"options": {
					"mangle": true,
					"compress": true
				},
				"prepublish": {
					"files": {
						"assets/js/main.js": "assets/js/main.js"
					}
				}
			},
			"watcher": {
				"coffee": {
					"files": ["assets/coffee/**/*.coffee"],
					"tasks": ["coffee"]
				},
				"less": {
					"files": ["assets/less/**/*.less"],
					"tasks": ["less:dev"]
				},
				"js": {
					"files": "<%= concat.files.src %>",
					"tasks": ["concat"]
				}
			},
			"load_npm_tasks": ["grunt-contrib-coffee", "grunt-contrib-concat", "grunt-contrib-less", "grunt-contrib-uglify", "grunt-contrib-watch"],
			"register_tasks": {
				"watcher:coffee": ["coffee", "watch:coffee"],
				"watcher:js": ["concat", "watch:js"],
				"watcher:less": ["less:dev", "watch:less"],
				"prepublish": ["coffee", "less:prepublish", "uglify"]
			},
			"proxy": false
		}
		"""

