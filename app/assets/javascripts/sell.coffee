# Created: Daniel Swain
# Date: 05/04/2016
# 
# The following coffeescript are for all sales pages.

$(document).ready ->
	# Sort dropdown for manage page, combo action replaces previous elements text with selection from dropdown
	$('#manage-filter').dropdown action: 'combo'

	# make the manage property table header sticky, it sticks to the ui.cards which is the next element
	$('.ui.sticky').sticky
		offset: 50
		context: '.ui.cards'

	return