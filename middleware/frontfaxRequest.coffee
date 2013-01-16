module.exports = (workspace)->
	(req, res, next)->
		match = req.url.match /^\/([^\/]+)/
		if match
			project  = match[1]
			filesURL = "/#{project}/r/SysConfig/WebPortal/#{project}/_files"
			req.__defineGetter__ 'cssURL', -> "#{filesURL}/css"
			req.__defineGetter__ 'jsURL', -> "#{filesURL}/js"
			req.__defineGetter__ 'projectDir', -> "#{workspace}/#{project}"
			req.__defineGetter__ 'assetsDir', -> "#{req.projectDir}/assets"
			req.__defineGetter__ 'buildDir', -> "#{req.projectDir}/build"
			req.__defineGetter__ 'lessDir', -> "#{req.assetsDir}/less"
			req.__defineGetter__ 'cssDir', -> "#{req.buildDir}/css"
			req.__defineGetter__ 'jsDir', -> "#{req.assetsDir}/js"
			req.__defineGetter__ 'jsBuildDir', -> "#{req.buildDir}/js"
		next()

