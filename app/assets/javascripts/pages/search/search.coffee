# Created: Jayden Spencer
# Date: 27/04/2016
# 
# The following coffeescript is for the search page
# 
# TODO:
#
ready = ->
	$('.ui.sticky.search-submenu').sticky
		offset: 71
		context: '#search-feed'
	$('.search-container .search-filter').dropdown
		allowCategorySelection: true
	#fav a property by adding favd class toggle
	$('.property-card .fav-property').click( ->
		$(this).children('i').toggleClass('favd'))
	#remove label in nav menu when the x is clicked
	$('.delete.icon').click( ->
		$(this).parent().remove())
	

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready