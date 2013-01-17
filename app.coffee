# Required dependencies
connect    = require 'connect'
path       = require 'path'
http       = require 'http'
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
app.use middleware.less path.join bootstrap, 'less'
app.use (req, res, next)->
	stat = middleware.static req.cssDir, req.cssURL
	stat req, res, next

# JS 
app.use middleware.mainjs()

app.use (req, res, next)->
	stat = middleware.static path.join(bootstrap, 'js'), "#{req.jsURL}/bootstrap"
	stat req, res, next

app.use (req, res, next)->
	stat = middleware.static req.jsDir, req.jsURL
	stat req, res, next

# Look in the workspace directory
app.use connect.static workspace

# Then proxy to the configured production server
app.use middleware.proxy config.get('PRODUCTION_HOST'), config.get('PRODUCTION_PORT')

# Starts the server
app.start = ->
	app.listen 8080, ->
		console.log 'Server listening on port 8080'

module.exports = app

