#   Created: Daniel Swain
#   Date: 07/04/2016
#   
#   Testing out infinite scrolling/pagination.

# Trigger a new page load
tester = ->
	$('footer').hide()
	$('.infinite-table').infinitePages
		buffer: 100 # Auto scroll when 100px from bottom of window
		loading: ->
			$(this).text 'Loading next page...'
		error: ->
			$(this).button 'There was an error, please try again'
	return
	
$(document).ready tester
$(document).on 'page:change', tester