Base = require './Base'

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

		if @less
			json.load_npm_tasks.push 'grunt-contrib-less'

			json.watcher.less =
				files : ['assets/less/**/*.less']
				tasks : ['less:dev']

			json.less =
				dev:
					options : {paths: ['assets/less']}
					files   : {'assets/css/main.css': 'assets/less/main.less'}
				prepublish:
					files   : '<%= less.dev.files %>'
					options :
						paths    : '<%= less.dev.options.paths %>'
						compress : yes

			json.register_tasks['watcher:less'] = ['less:dev', 'watch:less']

		if @coffee
			json.load_npm_tasks.push 'grunt-contrib-coffee'

			json.watcher.coffee =
				files: ['assets/coffee/**/*.coffee']
				tasks: ['coffee']

			json.coffee =
				options: {base: no}
				files:
					expand : yes
					cwd    : 'assets/coffee'
					src    : ['**/*.coffee']
					dest   : 'assets/js/src/'
					ext    : '.js'

			json.register_tasks['watcher:coffee'] = ['coffee', 'watch:coffee']

		JSON.stringify json, null, 2

