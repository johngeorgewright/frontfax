task 'build', 'The post install script', ->
	fs      = require 'fs'
	exec    = require('child_process').exec
	bin     = 'build/bin/frontfax.js'

	exec "node_modules/.bin/coffee -c -b -o build src", (error, stdout, stderr)->
		if error
			console.log error.message
		else if stderr
			console.log stderr
		else
			console.log stdout

			fs.readFile bin, (err, data)->
				unless err
					data = "#!/usr/bin/env node\n\n#{data.toString()}"
					fs.writeFile bin, data

