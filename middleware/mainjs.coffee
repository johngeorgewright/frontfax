combine = require '../lib/combine'

module.exports = (mainName='main.js')->
	(req, res, next)->

		if req.url is "#{req.jsURL}/#{mainName}"

			combine.dir req.jsDir, '.js', (err, output)->
				if err
					next()
				else
					res.end output

		else
			next()

