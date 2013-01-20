config      = require 'config'
controllers = require './controllers'
express     = require 'express'
http        = require 'http'
path        = require 'path'
app         = express()
assets      = path.resolve 'assets'

# Basic configuration
app.configure ->
	app.set 'port', process.env.PORT or 8080
	app.set 'views', path.join __dirname, 'views'
	app.set 'view engine', 'jade'
	app.use express.logger 'dev'
	app.use express.methodOverride()
	app.use app.router
	app.use express.errorHandler()

if config.proxy?
	app.use controllers.proxy.buffer()

# Fetch images from a configured source
if config.assets?.images?
	app.use config.assets.images, express.static path.join assets, 'images'

# CSS
if config.assets?.css?
	app.use config.assets.css, express.static path.join assets, 'css'

# Fetch js from a configured directory
if config.assets?.js?
	app.use config.assets.js, express.static path.join assets, 'js'

# Add a base URL to all requests
if config.base? and config.base
	child = app
	app   = express()
	app.configure ->
		app.set 'port', child.get 'port'
		app.use controllers.proxy.buffer() if config.proxy?
		app.use config.base, child

# Proxy unsuccessfull request to a configured server
if config.proxy?
	app.use controllers.proxy.request config.proxy

# Starts the app
app.start = ->
	server = http.createServer app
	port   = app.get 'port'
	server.listen port, ->
		console.log "Frontfax server listening on port #{port}"

module.exports = app

