# Created: Jayden Spencer
# Date: 27/04/2016
# 
# The following coffeescript is for the search page
# 
# TODO:
# add a false to search so it has a tool tip to add some criteria or sililar
ready = ->
	#search button and call search toconfigure query
	$('#buy-search-submit').click ->
		doSearch()

	doSearch = ->
		#initialise array for search suburbs, price tags, property tags and feature tags
		search_tags = []
		property_tags = []
		feature_tags = []
		price_tags = []
		#get each :selected tag and push their value into the search_tags array
		$('#search-field :selected').each ->
			search_tags.push $(this).val()
		if $('#location div').length
			#iterate through suburb tags
			$('#location .suburb-label').each ->
				sub = 'suburb_' + $(this).data('subid')
				search_tags.push sub

		# Get the extra search criteria added via the 'Add Search Criteria' dropdown
		additional_criteria_tags = $('.criteria-tag-field a')
		if additional_criteria_tags.length
			# Split these into tag arrays based on their type
			additional_criteria_tags.each ->
				# Get the additional criteria category (i.e. Heating Cooling) from the data-cat value
				# Get the additional criteria label (i.e. $100,000) from the data-catid value
				category = $(this).data 'cat'
				tag_label = $(this).data 'catid'
				# Add the tag to either property_tags, feature_tags or price_tags depending on the category
				switch category
					when 'Price'
						price_tags.push tag_label
					when 'Features'
						feature_tags.push tag_label
					when 'Property'
						property_tags.push tag_label

		#there is length to the seach thats perform ajax action to search page and query
		# This doesn't actually do anything atm. It will allow a blank search
		if search_tags
			$.ajax
				type: 'POST'
				url: '/search#get_search'
				data:
					_method: 'PUT'
					search_values: JSON.stringify(search_tags)
					price_values: JSON.stringify(price_tags)
					feature_values: JSON.stringify(feature_tags)
					property_values: JSON.stringify(property_tags)
			return true

	#sticky nav
	$('.ui.sticky.search-submenu').sticky
		offset: 71
		context: '#search-feed'
	$('.search-container .search-filter').dropdown
		allowCategorySelection: true
	#fav a property by adding favd class toggle
	#$('.property-card .fav-property').click( ->
	#	$(this).children('i').toggleClass('favd'))
	#remove label in nav menu when the x is clicked
	$('.search-submenu .delete.icon').click( ->
		#remove from navbar
		$(this).parent().remove()
		#perform click on search, to reload the page without the new tag
		doSearch())	

	#So this is erdals attempt at doing the coffee script for favouriting a property
	#no where near done
	$('.fav-property').click (->
		listing_id = $(this).data 'id'
		if $(this).children('i').hasClass('favd')
			console.log 'Im inside and I have the class favd'
			is_favourited = "true"
		else
			console.log 'Im inside and I dont have the class favd'
			is_favourited = "false"

		if listing_id.length != 0 and is_favourited.length != 0
				$.ajax
					type: 'POST'
					url: 'toggle-favourites'
					data:
						_method: 'PUT'
						listing_id: listing_id
						is_favourited: is_favourited
					success: (response) ->
						console.log 'Im inside success'
						console.log $(this)
						$('a[data-id="' + listing_id + '"]').children('i').toggleClass('favd'))

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
