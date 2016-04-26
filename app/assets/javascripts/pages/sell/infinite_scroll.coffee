#    Created: Daniel Swain
#    Date: 18/04/2016
#    
#    Coffeescript file containing all infinite scroll javascript for sell pages
#    
#    Todo: figure out how to get the loading animation to load on the first page load (it loads on all subsequent page loads)

# Function containing all javascript needed on page load
ready = ->
	#--------- Infinite Scroll Code
	# Hanlde infinite scroll of manage properties cards table
	# Can experiment with different buffers (where the scroll is triggerd as a distance from the bottom of the window) by adding
	# buffer: XXX <- where XXX is the integer value from the screen bottom the loading will trigger from.
	# Default is 1000 (i.e. 1000px) and seems good enough.
	# I've found that if you actually want to see the link you need to set a negative link. it should be greater than -250 (i.e -200)
	# to ensure the page automatically loads, if the buffer is smaller than -250 we can't trigger it automatically.
	$('.infinite-table').infinitePages
		# buffer: -250
		# Change the state of the pagination link on loading and error.
		loading: ->
			# Change the link text
			$(this).text 'Loading more'
		error: ->
			# Change the link text
			$(this).text 'There was an error retrieving more listings, please try again'
	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready
