Base = require './Base'

module.exports = class Grunt extends Base

	filename: ->
		'Gruntfile.js'

	content: ->
		"""
		var config = require('config'),
		    util   = require('util');

		module.exports = function(grunt) {

			var gruntConfig = {},
				i, key;

			for(key in config){
				if(config.hasOwnProperty(key) && key !== 'watch'){
					gruntConfig[key] = config[key];
				}
			}

			grunt.initConfig(util._extend(gruntConfig, {
				pkg   : grunt.file.readJSON('package.json'),
				watch : gruntConfig.watcher
			}));

			if(gruntConfig.load_npm_tasks){
				for(i=0; i<gruntConfig.load_npm_tasks.length; i++){
					grunt.loadNpmTasks(gruntConfig.load_npm_tasks[i]);
				}
			}

			if(gruntConfig.register_tasks){
				for(key in gruntConfig.register_tasks){
					if(gruntConfig.register_tasks.hasOwnProperty(key)){
						grunt.registerTask(key, gruntConfig.register_tasks[key]);
					}
				}
			}

		};
		"""

