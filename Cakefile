task 'postinstall', 'The post install script', ->
	fs      = require 'fs'
	spawn   = require('child_process').spawn
	bin     = 'build/bin/frontfax.js'
	options = ['-c', '-b', '-o', 'build', 'src']
	coffee  = spawn 'node_modules/.bin/coffee', options

	coffee.on 'exit', ->
		fs.readFile bin, (err, data)->
			unless err
				data = "#!/usr/bin/env node\n\n#{data.toString()}"
				fs.writeFile bin, data

