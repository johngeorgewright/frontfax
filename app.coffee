# Required dependencies
connect    = require 'connect'
path       = require 'path'
http       = require 'http'
less       = require 'less-middleware'
path       = require 'path'
fs         = require 'fs'
middleware = require './middleware'
config     = require('./config')()

# The app object
app = connect()

# App configuration
workspace = config.get 'WORKSPACE'
bootstrap = config.get 'BOOTSTRAP_PATH'

# Log the configuration
console.log "Retrieving remote files from #{config.get 'PRODUCTION_HOST'}:#{config.get 'PRODUCTION_PORT'}"
console.log "Retrieving local files from #{workspace}"

# Console logging
app.use connect.logger 'dev'

# Per request config
app.use middleware.frontfaxRequest workspace

# LESS and Bootstrap
app.use '/img', connect.static path.join bootstrap, 'img'

app.use (req, res, next)->
	compiler = less
		src    : req.lessDir
		paths  : path.join bootstrap, 'less'
		dest   : req.cssDir
		prefix : req.cssURL
		debug  : true
	compiler req, res, next

app.use middleware.static req.cssDir, req.cssURL

# JS 
app.use middleware.static path.join(bootstrap, 'js'), "#{req.jsURL}/bootstrap"
app.use middleware.static req.jsDir, req.jsURL

# First look in the workspace directory
app.use connect.static workspace

# Then proxy to the configured production server
app.use (req, res, next)->
	options =
		hostname : config.get('PRODUCTION_HOST')
		port     : config.get('PRODUCTION_PORT')
		path     : req.url
		method   : req.method

	proxyReq = http.request options, (proxyRes)->
		proxyRes.pipe res
		# Make sure that redirects don't forward to production server
		if proxyRes.headers.location?
			proxyRes.headers.location = proxyRes.headers.location.replace "#{config.get('PRODUCTION_HOST')}:#{config.get('PRODUCTION_PORT')}", req.headers.host
		res.writeHead proxyRes.statusCode, proxyRes.headers

	req.pipe proxyReq

# Starts the server
app.start = ->
	app.listen 8080, ->
		console.log 'Server listening on port 8080'

module.exports = app

