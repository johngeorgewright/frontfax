fs     = require 'fs'
path   = require 'path'
assert = require 'assert'
mkdirp = require 'mkdirp'

module.exports = class Base

	constructor: (options)->
		@[key] = value for own key, value of options

	filename: ->
		"#{@constructor.name}.js"

	content: ->
		''

	render: (callback)->
		base     = @base ? '.'
		filename = "#{base}/#{@filename()}"
		dirname	 = path.dirname filename

		mkdirp dirname, (err)=>
			assert.ifError err

			fs.writeFile filename, @content(), (err)->
				assert.ifError err
				console.log " + #{filename}"
				callback() if callback

