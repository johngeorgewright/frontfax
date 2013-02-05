Base = require './Base'

module.exports = class GitIgnore extends Base

  filename: ->
    '.gitignore'

  content: ->
    """
	assets/css
	config/runtime.json
    node_modules
    .exrc
    *.log
    *.swp
    """

