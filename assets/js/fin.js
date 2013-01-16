require.config({
	baseUrl: '/brw2/r/SysConfig/WebPortal/brw2/_files/js',
	paths: {
		jquery: '//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min',
		'bootstrap/collapse': 'bootstrap/bootstrap-collapse',
		'bootstrap/dropdown': 'bootstrap/bootstrap-dropdown'
	},
	shim: {
		jquery: {
			exports: 'jQuery'
		},
		'bootstrap/collapse': {
			deps: ['jquery']
		},
		'bootstrap/dropdown': {
			deps: ['jquery']
		}
	}
});

