combine = require '../lib/combine'

module.exports = (mainName='main.js')->
	(req, res, next)->

		if req.url is "#{req.jsURL}/#{mainName}"

			combine.dir req.jsDir, '.js', (err, output)->
				next err if err
				res.end output

		else
			next()

