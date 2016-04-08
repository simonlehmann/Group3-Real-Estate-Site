# Created: Daniel Swain
# Date: 05/04/2016
# 
# The following coffeescript are for all sales pages.

# Function containing all javascript needed on page load
ready = ->
	# Sort dropdown for manage page, combo action replaces previous elements text with selection from dropdown
	$('#manage-filter').dropdown action: 'combo'
	# make the manage property table header sticky, it sticks to the ui.cards which is the next element
	console.log(window.location.pathname)
	$('.ui.sticky').sticky
		offset: 60
		context: '.ui.cards'	
	
	# Refresh the manage property table header sticky if the page contains sell as it was not getting sized correctly.
	if window.location.pathname.includes('sell')
		$('.ui.sticky').sticky 'refresh'

	# Support tab's on the add_edit page
	$('.add-edit.tabular.menu .item').tab()

	# Status modal on manage page code
	# Launch the modal
	$('.manage-status.modal').modal 'attach events', '.manage-status.ribbon', 'show'
	# Accordian trigger change
	$('.manage-status.modal .accordion').accordion selector: trigger: '.title'
	# Attach a trigger event to the checkbox radio's so that the checkbox label also triggers it.
	$('.manage-status.modal .accordion .ui.checkbox').checkbox 'attach events', $('.manage-status.modal .accordion .ui.checkbox .label')

	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready