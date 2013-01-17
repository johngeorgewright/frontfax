connect = require 'connect'
utils   = require 'connect/lib/utils'

module.exports = (path, baseURL)->
	(req, res, next)->

		pathname = utils.parseUrl(req).pathname
		pathname = '/' if pathname is undefined
		return next() unless pathname.indexOf(baseURL) is 0

		originalURL = req.url
		req.url     = req.url.substr baseURL.length
		req.url     = "/#{req.url}" unless req.url[0] is '/'
		stat        = connect.static path

		stat req, res, (err)->
			req.url = originalURL
			next err

