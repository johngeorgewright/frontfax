util    = require '../../lib/util'
colors  = require 'colors'
express = require 'express'

exports.extractPort = ->
	(req, res, next)->
		req.port = res.app.get 'port'
		next()

contentReplacer = (replacements, method)->
	(chunk, encoding)->
		isText = /text\//.test @get('Content-Type')
		if chunk? and isText
			newChunk = chunk.toString encoding
			for own key, replacement of replacements
				newChunk = newChunk.replace replacement.reg, replacement.value
			try
				chunk = new Buffer newChunk, encoding
				#if @get 'content-length'
					#@set 'content-length', chunk.length
		method.call @, chunk, encoding

exports.replaceInResponse = (app, replacements)->
	replacementsCopy = {}

	for own key, value of replacements
		console.log "Will be replacing \"#{key}\" with \"#{value}\""
		replacementsCopy[key] =
			reg   : new RegExp util.escapeRegExp(key), 'g'
			value : value
	
	res       = app.response
	res.end   = contentReplacer replacementsCopy, res.end
	res.write = contentReplacer replacementsCopy, res.write

exports.loggerFormat = (tokens, req, res)->
	proxy   = res.getHeader 'proxied'
	output  = if proxy then 'PROXY '.grey else ''
	output += express.logger.dev tokens, req, res

