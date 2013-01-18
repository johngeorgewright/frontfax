config      = require 'config'
controllers = require './controllers'
express     = require 'express'
http        = require 'http'
less        = require 'less-middleware'
path        = require 'path'
app         = express()

# Basic configuration
app.configure ->
	app.set 'port', process.env.PORT or 8080
	app.set 'views', path.join __dirname, 'views'
	app.set 'view engine', 'jade'
	app.use express.logger 'dev'
	app.use express.methodOverride()
	app.use app.router
	app.use express.errorHandler()

# Fetch images from a configured source
if config.assets.images?
	app.get config.assets.images.url, express.static(config.assets.images.source)

# Build less files from a configured source
if config.assets.less?
	app.get config.assets.less.url, less
		src    : config.assets.less.source
		dest   : config.assets.less.dest
		prefix : path.dirname config.assets.less.url
		paths  : path.join __dirname, 'node_modules', 'bootstrap', 'less'
		debug  : true
	app.use path.dirname(config.assets.less.url), express.static(config.assets.less.dest)

# Combine all js files from one directory
if config.assets.js?.combine?
	app.get config.assets.js.combine.url, controllers.assets.combine
		source    : config.assets.js.source
		extension : 'js'

# Fetch js from a configured directory
if config.assets.js?
	app.use path.dirname(config.assets.js.url), express.static(config.assets.js.source)

# Add a base URL to all requests
if config.base?
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

