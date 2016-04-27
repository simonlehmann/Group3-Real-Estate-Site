ready = ->
	$('.ui.sticky.dashboard-submenu').sticky
		offset: 71
		context: '#activity-feed'

	# Initialise the tab menu
	$('.dashboard-submenu .dashboard-tabular.menu .item').tab(
		# On tab load, change the window history so the path mirrors the active tab (without redirecting the page)
		onLoad: ->
			window.history.replaceState('activeTab', '', '/dashboard/' + $('#activity-feed .tab.active').attr('data-tab'))
		)

$(document).ready ready
$(document).on 'page:load', ready
