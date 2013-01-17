md   = require 'github-flavored-markdown'
fs   = require 'fs'
path = require 'path'

module.exports = ->
	(req, res, next)->

		unless req.url is '/' and req.method is 'GET'
			next()

		else
		
			readmeFile = path.join __dirname, '..', 'README.md'

			fs.readFile readmeFile, (err, data)->
				next err if err
				html = md.parse data.toString()
				res.writeHead 200, 'text/html'
				res.end "
				<!doctype html>
				<html lang=\"en\">
					<head>
						<meta encoding=\"utf8\"/>
						<title>Frontfax</title>
						<link rel=\"stylesheet\" type=\"text/css\" href=\"http://yui.yahooapis.com/combo?3.8.0/build/cssreset/cssreset-min.css&3.8.0/build/cssfonts/cssfonts-min.css&3.8.0/build/cssbase/cssbase-min.css\"/>
						<style>
							body { width:990px; margin:0 auto; }
							.highlight { background-color:#EFEFEF; padding:10px; border-radius:3px; }
						</style>
					</head>
					<body>
						#{html}
					</body>
				</html>
				"

