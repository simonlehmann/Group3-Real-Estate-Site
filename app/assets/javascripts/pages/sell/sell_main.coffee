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
		# Now we have the sort method, lets send this to our sell controller to handle the sort and update the view
		# There's no success handler as it's done by manage.js.erb
		$.ajax
			type: 'POST'
			url: '/update-sort'
			data:
				_method: 'PUT'
				listing_filter: selected_item

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
