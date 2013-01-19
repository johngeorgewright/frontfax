Base = require './Base'

module.exports = class GitIgnore extends Base

  filename: ->
    '.gitignore'

  content: ->
    """
    node_modules
    .exrc
    *.log
    *.swp
    """

