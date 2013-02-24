Base = require './Base'
util = require '../../../lib/config'

module.exports = class Config extends Base

	filename: ->
		'config/default.json'

	content: ->
		json =
			base    : off
			proxy   : off
			images  : {paths: '/images'}
			css     : {paths: '/stylesheets'}
			js      : {paths: '/js'}

			concat:
				files:
					src  : 'assets/js/src/**/*.js'
					dest : 'assets/js/main.js'

			uglify:
				options:
					mangle   : yes
					compress : yes
				prepublish:
					files:
						'assets/js/main.js': 'assets/js/main.js'

			watcher:
				js:
					files: '<%= concat.files.src %>'
					tasks: ['concat']

			load_npm_tasks: [
				'grunt-contrib-concat'
				'grunt-contrib-uglify'
				'grunt-contrib-watch'
			]

			register_tasks:
				'watcher:js'     : ['concat', 'watch:js']
				'prepublish'     : ['coffee', 'less:prepublish', 'uglify']

		util.addLess json if @less
		util.addCoffee json if @coffee

		JSON.stringify json, null, 2

