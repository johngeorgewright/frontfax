Base = require './Base'
pack = require '../../../../../package.json'
util = require '../../../lib/package'

module.exports = class Package extends Base

	filename: ->
		'package.json'

	content: ->
		json =
			name         : @name
			version      : '0.0.0'
			description  : 'Another Frontfax environment'
			scripts      : {start: 'nf start'}
			author       : @author
			dependencies :
				frontfax               : pack.version
				config                 : '0.4.18'
				foreman                : '0.0.23'
				grunt                  : '~0.4.0'
				'grunt-cli'            : '~0.1.6'
				'grunt-contrib-concat' : '~0.1.2'
				'grunt-contrib-uglify' : '~0.1.1'
				'grunt-contrib-watch'  : '~0.2.0'

		if @less
			util.addLess json

		if @coffee
			util.addCoffee json

		JSON.stringify json, null, 2

