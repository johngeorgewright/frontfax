assert  = require 'assert'
combine = require '../../lib/combine'

exports.combine = (options)->
	assert.ok options.source, 'options.source is required'
	(req, res)->
		combine.dir options.source, '.'+options.extension, (err, data)->
			assert.ifError err
			res.type options.extension
			res.send data

