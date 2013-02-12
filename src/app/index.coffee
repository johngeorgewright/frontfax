config      = require 'config'
controllers = require './controllers'
express     = require 'express'
http        = require 'http'
path        = require 'path'
app	        = express()
assets      = path.resolve 'assets'
assetTypes  = ['images', 'css', 'js']

# Auth
if config.auth?
	throw new Error "You need to supply at least a username" unless config.auth.username?
	throw new Error "You also need to supply a password" unless config.auth.password?
	app.use express.basicAuth config.auth.username, config.auth.password

# Basic configuration
app.configure ->
	app.set 'port', process.env.PORT or 8080
	app.use express.logger 'dev'
	app.use controllers.util.extractPort()
	app.use express.methodOverride()
	controllers.socket.refreshClient app
	if config.replacements
		controllers.util.replaceInResponse app, config.replacements
	app.use app.router
	app.use express.errorHandler()

# Fetch static content
for assetType in assetTypes
	if config[assetType]?.paths?
		assetTypePaths = config[assetType].paths
		assetTypePaths = [assetTypePaths] unless assetTypePaths instanceof Array
		for assetTypePath in assetTypePaths
			app.use assetTypePath, express.static path.join assets, assetType

# Try and see if the correct jade file exists
app.use controllers.jade.render path.resolve 'static'

# Try and see if the correct coffeecup file exists
app.use controllers.coffeecup.render path.resolve 'static'

# Lastly look for anything in the static directory
app.use express.static path.resolve 'static'

# Add a base URL to all requests
if config.base? and config.base
	child = app
	app	 = express()

	app.configure ->
		app.set 'port', child.get 'port'
		app.use app.router
		app.use config.base, child

	baseReg = config.base.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&'
	baseReg = new RegExp "^(?!#{baseReg})"
	app.get baseReg, (req, res)->
		res.redirect "#{config.base}#{req.originalUrl}"

# Proxy unsuccessfull requests to a configured server
if config.proxy? and config.proxy
	app.use controllers.proxy.request config.proxy

# Starts the app
app.start = ->
	server = http.createServer app
	port	 = app.get 'port'
	server.listen port, ->
		console.log "Frontfax server listening on port #{port}"
		controllers.socket.refreshServer server

module.exports = app

