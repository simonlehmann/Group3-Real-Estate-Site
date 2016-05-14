# Created: Jayden Spencer
# Date: 27/04/2016
# 
# The following coffeescript is for the search page
# 
# TODO:
# add a false to search so it has a tool tip to add some criteria or sililar
ready = ->
	#get suburb data from suburb container that gets data from the controller
	#suburb_tags = $('.suburb-container').data 'suburbs'
	#suburb_ids = $('.suburb-container').data('subids')
	#loop though the suburb tags and append to side nav

	#search button and call search toconfigure query
	$('#buy-search-submit').click( ->
		doSearch()

	doSearch = ->
		#initialise array
		search_tags = []
		#get each :selected tag and push their value into the search_tags array
		$('#search-field :selected').each ->
			search_tags.push $(this).val()
		if suburb_tags != null
			$('#location .suburb-label').each ->
				sub = 'suburb_' + $('.suburb-label').data('suburbid')
				console.log sub
				search_tags.push sub
				
		#there is length to the seach thats perform ajax action to search page and query
		if search_tags
			$.ajax
				type: 'POST'
				url: '/search#get_search'
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
		#remove from navbar
		$(this).parent().remove()
		suburb_tags.splice($.inArray($(this).text(), suburb_tags),1);
		suburb_ids.splice($.inArray($(this).data('suburbid'), suburb_ids),1);
		#perform click on search, to reload the page without the new tag
		doSearch())	

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
