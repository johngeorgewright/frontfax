socket = io.connect "#{window.location.protocol}//#{window.location.host}"

socket.on 'refreshAll', ->
	window.location.reload()

socket.on 'refreshCSS', ->
	styles = document.getElementsByTagName 'link'
	stamp  = new Date().getTime()
	i      = 0

	for style in styles
		if style.getAttribute('rel') is 'stylesheet'
			style.href = style.href.replace /\?.*|$/, "?stamp=#{stamp}"

