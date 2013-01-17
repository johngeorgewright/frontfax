less         = require 'less'
util         = require 'util'
path         = require 'path'
fs           = require 'fs'
mkdirp       = require 'mkdirp'
connectUtils = require 'connect/lib/utils'

module.exports = (paths, compress=false)->

	(req, res, next)->

		pathname = connectUtils.parseUrl(req).pathname
		return next() unless pathname.indexOf(req.cssURL) is 0

		# TODO: Need to create directories in destination

		base     = req.url.substr req.cssURL.length
		pathname = "#{req.lessDir}#{base}"
		dirname  = path.dirname pathname
		extname  = path.extname pathname
		basename = path.basename pathname, extname
		lessname = "#{dirname}/#{basename}.less"
		cssname  = "#{req.cssDir}/#{base}"

		# For some reason, when performing this method
		# asyncronously, the http proxy can no longer
		# work :s God knows...
		return next() unless fs.existsSync lessname

		console.log "Compiling #{lessname} to #{cssname}"

		includePaths = []
		includePaths.push p for p in paths
		includePaths.unshift req.lessDir
		
		parser = new less.Parser
			paths    : includePaths
			filename : lessname

		fs.readFile lessname, (err, data)->
			return next err if err

			parser.parse data.toString(), (e, tree)->
				return next err if err

				css = tree.toCSS compress: compress

				mkdirp path.dirname(cssname), (err)->
					return next err if err

					fs.writeFile cssname, css, (err)->
						next err if err
						res.writeHead 200, 'text/css'
						res.end css

