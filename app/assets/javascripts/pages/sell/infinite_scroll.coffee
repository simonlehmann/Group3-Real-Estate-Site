#    Created: Daniel Swain
#    Date: 18/04/2016
#    
#    Coffeescript file containing all infinite scroll javascript for sell pages

# Function containing all javascript needed on page load
ready = ->
	#--------- Infinite Scroll Code
	# Hanlde infinite scroll of manage properties cards table
	# Can experiment with different buffers (where the scroll is triggerd as a distance from the bottom of the window) by adding
	# buffer: XXX <- where XXX is the integer value from the screen bottom the loading will trigger from.
	# Default is 1000 (i.e. 1000px) and seems good enough.
	$('.infinite-table').infinitePages
		# Change the state of the pagination link on loading and error.
		loading: ->
			# Change the link text
			$(this).text 'Loading more listings...'
		error: ->
			# Change the link text
			$(this).text 'There was an error retrieving more listings, please try again'

	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready
