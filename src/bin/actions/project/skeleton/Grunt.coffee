Base = require './base'

module.exports = class Grunt extends Base

	filename: ->
		'grunt.js'

	content: ->
		"""
		module.exports = function(grunt) {

			// Project configuration.
			grunt.initConfig({
				pkg: '<json:package.json>',
				concat: {
					js: {
						src: 'assets/js/**.js',
						dest: 'assets/js/main.js'
					}
				},
				less: {
					dev: {
						options: {
							paths: ['assets/less']
						},
						files: {
							'assets/css/main.css': 'assets/less/main.less'
						}
					},
					dist: {
						options: {
							paths: '<config:less.dev.options.pahts>',
							compress: true
						},
						files: '<config:less.dev.files>'
					}
				},
				uglify: {
					dist: '<config:concat.js>'
				},
				watch: {
					less: {
						files: 'assets/**',
						tasks: 'less:dev'
					},
					js: {
						files: '<config:watch.less.files>',
						tasks: 'concat:js'
					}
				}
			});

			grunt.loadNpmTasks('grunt-contrib-uglify');
			grunt.loadNpmTasks('grunt-contrib-less');
			grunt.registerTask('dist', ['less:dist']);

		};
		"""

