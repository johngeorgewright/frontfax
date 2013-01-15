connect    = require 'connect'
path       = require 'path'
http       = require 'http'
app        = connect()
workspace  = process.env.WORKSPACE ? path.join __dirname, '..', 'frontfax-workspace'
production =
	host: process.env.PRODUCTION_HOSTNAME ? '172.16.133.43'
	port: process.env.PRODUCTION_PORT     ? 51161

# Log the configuration
console.log "Retrieving remote files from #{production.host}:#{production.port}"
console.log "Retrieving local files from #{workspace}"

# Console logging
app.use connect.logger 'dev'

# First look in the workspace directory
app.use connect.static workspace

# Then proxy to the configured production server
app.use (req, res, next)->
	options =
		hostname : production.host
		port     : production.port
		path     : req.url
		method   : req.method

	proxyReq = http.request options, (proxyRes)->
		proxyRes.pipe res
		# Make sure that redirects don't forward to production server
		if proxyRes.headers.location?
			proxyRes.headers.location = proxyRes.headers.location.replace "#{production.host}:#{production.port}", req.headers.host
		res.writeHead proxyRes.statusCode, proxyRes.headers

	req.pipe proxyReq

# Starts the server
app.start = ->
	app.listen 8080, ->
		console.log 'Server listening on port 8080'

module.exports = app

