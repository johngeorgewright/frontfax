exports.addLess = (pack)->
	pack.dependencies['grunt-contrib-less'] = '~0.5.0'
	pack

exports.addCoffee = (pack)->
	pack.dependencies['grunt-contrib-coffee'] = "~0.4.0"
	pack

