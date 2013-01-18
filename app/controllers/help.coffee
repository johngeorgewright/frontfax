marked      = require 'marked'
path        = require 'path'
fs          = require 'fs'
highlighter = require 'highlight.js'

exports.readme = (req, res)->
	marked.setOptions
		gfm       : yes
		tables    : yes
		breaks    : no
		pendantic : no
		sanitize  : yes
		highlight : (code, lang)->
			highlighter.highlightAuto(code).value

	readme = path.join __dirname, '..', '..', 'README.md'

	fs.readFile readme, (err, data)->
		return res.send 500, err if err

		html = marked data.toString()

		res.render 'help/readme', html: html

