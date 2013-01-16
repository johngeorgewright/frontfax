less = require 'less-middleware'

module.exports = (paths)->
	(req, res, next)->
		compiler = less
			src    : req.lessDir
			paths  : paths
			dest   : req.cssDir
			prefix : req.cssURL
			debug  : true
		compiler req, res, next

