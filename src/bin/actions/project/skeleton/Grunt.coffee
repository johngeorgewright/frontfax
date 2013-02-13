Base = require './Base'

module.exports = class Grunt extends Base

	filename: ->
		'grunt.js'

	content: ->
		"""
		var config = require('config'),
		    util   = require('util');

		module.exports = function(grunt) {

			var gruntConfig = {},
				key;

			for(key in config){
				if(config.hasOwnProperty(key) && key !== 'watch'){
					gruntConfig[key] = config[key];
				}
			}

			grunt.initConfig(util._extend(gruntConfig, {
				pkg   : '<json:package.json>',
				watch : gruntConfig.watcher
			}));

			if(config.less){
				grunt.loadNpmTasks('grunt-contrib-less');

				if(config.less.dev && config.watcher && config.watcher.less){
					grunt.registerTask('watcher:less:dev', ['less:dev', 'watch:less']);
				}

				if(config.less.prepublish){
					grunt.registerTask('prepublish', ['less:prepublish']);
				}
			}

			if(config.concat && config.watcher.js){
				grunt.registerTask('watcher:js:dev', ['concat:js', 'watch:js']);
			}

			if(config.coffee){
				grunt.loadNpmTasks('grunt-contrib-coffee');

				if(config.coffee.dev && config.watcher && config.watcher.coffee){
					grunt.registerTask('watcher:coffee:dev', ['coffee:dev', 'watch:coffee']);
				}
			}

		};
		"""

