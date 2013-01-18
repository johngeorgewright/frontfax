path      = require 'path'
filesURL  = "/r/SysConfig/WebPortal/brw/_files"
workspace = path.join __dirname, '..', 'workspace'

module.exports =
	base: '/brw'

	proxy:
		target:
			host: "172.30.6.11"
			port: 51161
	
	assets:
		images:
			url: "#{filesURL}/images"
			source: "#{workspace}/assets/images"

		less:
			url: "#{filesURL}/css/*.css"
			source: "#{workspace}/assets/less"
			dest: "#{workspace}/build/css"

		js:
			url: "#{filesURL}/js/*.js"
			source: "#{workspace}/assets/js"
			combine:
				url: "#{filesURL}/js/main.js"
				dest: "#{workspace}/build/js/main.js"

