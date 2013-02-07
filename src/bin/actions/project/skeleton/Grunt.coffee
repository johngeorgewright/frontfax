Base = require './base'

module.exports = class Grunt extends Base

	filename: ->
		'grunt.js'

	content: ->
		"""
		var config = require('config');

		module.exports = function(grunt) {

			// Project configuration.
			grunt.initConfig({
				pkg: '<json:package.json>',
				concat: config.concat,
				less: config.less,
				watch: config.watcher
			});

			grunt.loadNpmTasks('grunt-contrib-less');
			grunt.registerTask('watcher:less:dev', ['less:dev', 'watch:less']);
			grunt.registerTask('watcher:js:dev', ['concat:js', 'watch:js']);
			grunt.registerTask('prepublish', ['less:prepublish']);

		};
		"""

