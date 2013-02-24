exports.addLess = (config)->
	config.load_npm_tasks.push 'grunt-contrib-less'

	config.watcher.less =
		files : ['assets/less/**/*.less']
		tasks : ['less:dev']

	config.less =
		dev:
			options : {paths: ['assets/less']}
			files   : {'assets/css/main.css': 'assets/less/main.less'}
		prepublish:
			files   : '<%= less.dev.files %>'
			options :
				paths    : '<%= less.dev.options.paths %>'
				compress : yes

	config.register_tasks['watcher:less'] = ['less:dev', 'watch:less']

exports.addCoffee = (config)->
	config.load_npm_tasks.push 'grunt-contrib-coffee'

	config.watcher.coffee =
		files: ['assets/coffee/**/*.coffee']
		tasks: ['coffee']

	config.coffee =
		options: {base: no}
		files:
			expand : yes
			cwd    : 'assets/coffee'
			src    : ['**/*.coffee']
			dest   : 'assets/js/src/'
			ext    : '.js'

	config.register_tasks['watcher:coffee'] = ['coffee', 'watch:coffee']

