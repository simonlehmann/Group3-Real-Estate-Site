ready = ->
	$('.ui.sticky.dashboard-submenu').sticky
		offset: 71
		context: '#activity-feed'
$(document).ready ready
$(document).on 'page:load', ready