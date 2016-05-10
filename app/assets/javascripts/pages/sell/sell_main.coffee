# Created: Daniel Swain
# Date: 05/04/2016
# 
# The following coffeescript are for the main sales pages.
# 
# Todo:

# Function containing all javascript needed on page load for the manage page and index page
ready = ->
	#--------- Sort Dropdown Code
	# Sort dropdown for manage page, combo action replaces previous elements text with selection from dropdown
	$('#manage-filter').dropdown()

	# Handle the sort change via the update_sort Ajax action in sell_controller
	$('#manage-filter').change ->
		# Get the sort value from the dropdown
		selected_item = parseInt($('#manage-filter :selected').val())
		# Get the filter method and send that through (in case the user has changed from 'desc' to 'asc' and wants to change the sort type)
		filter_method = $('#manage-filter-method').data 'filter-method'
		# Now we have the sort method, lets send this to our sell controller to handle the sort and update the view
		# There's no success handler as it's done by manage.js.erb
		$.ajax
			type: 'POST'
			url: '/update-sort'
			data:
				_method: 'PUT'
				listing_filter: selected_item
				listing_filter_method: filter_method

	# Change the filter method form descending to ascending when clicked, but only if a filter choice is chosen
	$('#manage-filter-method').click ->
		# Get the selected_item and current filter method (shown on the button as an icon)
		selected_item = $('#manage-filter :selected').val()
		filter_method = $('#manage-filter-method').data 'filter-method'
		# Check for selection
		if !selected_item
			# No selection made so lets notify the user
			alert 'Please select a sorting option and try again.'
		else
			# The user has chosen a sorting option so lets send this through to the update-sort method
			# Get an integer from the selected item
			selected_item = parseInt(selected_item)
			# Change the filter method data value to the other type and change the icon
			if filter_method == 'desc'
				$('#manage-filter-method').data 'filter-method', 'asc'
				$('#manage-filter-method i').addClass('ascending')
				$('#manage-filter-method i').removeClass('descending')
				# Change the filter method to the oposite of what was on the button (the user clicking the button wants to change the filter method from what is listed)
				filter_method = 'asc'
			else
				$('#manage-filter-method').data 'filter-method', 'desc'
				$('#manage-filter-method i').addClass('descending')
				$('#manage-filter-method i').removeClass('ascending')
				# Change the filter method to the oposite of what was on the button (the user clicking the button wants to change the filter method from what is listed)
				filter_method = 'desc'
			# Send an ajax call to update the sort methodology
			$.ajax
				type: 'POST'
				url: '/update-sort'
				data:
					_method: 'PUT'
					listing_filter: selected_item
					listing_filter_method: filter_method
					listing_filter_reset: 'true'				

	#--------- Sticky Code
	# make the manage property table header sticky, it sticks to the ui.cards which is the next element
	$('.manage-table-header.ui.sticky').sticky
		offset: 60
		context: '.ui.cards'	
	# Refresh the manage property table header sticky if the page contains sell as it was not getting sized correctly.
	if window.location.pathname.includes('sell')
		$('.manage-table-header.ui.sticky').sticky 'refresh'
	
	# Popup tooltip for the approval corner label in the manage table cards when you hover over the label
	$('.manage-listing-card #listing-approval-label').popup	hoverable: true

	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready
