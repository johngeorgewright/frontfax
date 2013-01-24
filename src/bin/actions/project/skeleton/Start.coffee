Base = require './Base'

module.exports = class Start extends Base

	filename: ->
		'start.bat'

	content: ->
		'cmd /C npm start'

