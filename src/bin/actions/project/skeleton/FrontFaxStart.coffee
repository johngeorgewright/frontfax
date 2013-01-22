Base = require './base'

module.exports = class FrontFaxStart extends Base

	filename: ->
		'frontfaxstart.bat'

	content: ->
		"""
		Start frontfax server:start
		Start frontfax compile:less -w
		Start frontfax compile:js -b -w
		"""

