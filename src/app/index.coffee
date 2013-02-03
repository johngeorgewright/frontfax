config      = require 'config'
controllers = require './controllers'
express     = require 'express'
http        = require 'http'
path        = require 'path'
app         = express()
assets      = path.resolve 'assets'
arrs        = ['images', 'css', 'js']

# Auth
if config.auth?
  throw new Error "You need to supply at least a username" unless config.auth.username?
  throw new Error "You also need to supply a password" unless config.auth.password?
  app.use express.basicAuth config.auth.username, config.auth.password

# Basic configuration
app.configure ->
	app.set 'port', process.env.PORT or 8080
	app.set 'views', path.join __dirname, 'views'
	app.set 'view engine', 'jade'
	app.use express.logger 'dev'
	app.use express.methodOverride()
	app.use app.router
	app.use express.errorHandler()

# Fetch static content
for arr in arrs
  if config.assets?[arr]?
    config.assets[arr] = [config.assets[arr]] unless config.assets[arr] instanceof Array
    for staticPath in config.assets[arr]
      app.use staticPath, express.static path.join assets, arr

# Try and see if the correct jade file exists
# TODO: This breaks proxy
#app.use controllers.jade.render path.resolve 'static'

# Lastly look for anything in the static directory
app.use express.static path.resolve 'static'

# Add a base URL to all requests
if config.base? and config.base
	child = app
	app   = express()

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
	port   = app.get 'port'
	server.listen port, ->
		console.log "Frontfax server listening on port #{port}"

module.exports = app

