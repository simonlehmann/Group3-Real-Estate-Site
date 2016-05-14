# Created: Jayden Spencer
# Date: 27/04/2016
# 
# The following coffeescript is for the search page
# 
# TODO:
# add a false to search so it has a tool tip to add some criteria or sililar
ready = ->
	suburb_tags = $('.suburb-container').data 'suburbs'
	
	#search button and configure query
	$('#buy-search-submit').click( ->
		#initialise array
		search_tags = []
		#get each :selected tag and push their value into the search_tags array
		$('#search-field :selected').each ->
			search_tags.push $(this).val()
		#there is length to the seach thats perform ajax action to search page and query
		if search_tags.length
			$.ajax
				type: 'POST'
				url: '/search'
				data:
					_method: 'PUT'
					search_values: JSON.stringify(search_tags)
			return true)

	#sticky nav
	$('.ui.sticky.search-submenu').sticky
		offset: 71
		context: '#search-feed'
	$('.search-container .search-filter').dropdown
		allowCategorySelection: true
	#fav a property by adding favd class toggle
	$('.property-card .fav-property').click( ->
		$(this).children('i').toggleClass('favd'))
	#remove label in nav menu when the x is clicked
	$('.search-submenu .delete.icon').click( ->
		$(this).parent().remove())
	

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
