# Created: Jayden Spencer
# Date: 05/04/2016
# 
# The following coffeescript is for the index/buy page.
# 
# TODO:
# * Move lightbox to property page, when its time!
#
ready = ->
	# Add initial header image
	$('.search-section').addClass 'wa-img'
	#search dropdown
	$('.search-section .ui.dropdown').dropdown allowAdditions: true, fullTextSearch: true
	# Update the search dropdown options based upon the choice of state when it's changed via an ajax call
	$('#search-state-field').change ->
		# Get the state 
		state = $('#search-state-field :selected').val()
		# Clear the old data from the search dropdown
		$('#search-field').empty()
		$('#search-field').dropdown 'clear'
		changeImage(state)
		remove_classes(state)
		# Update the dropdown via an Ajax call to the server
		$.ajax
			type: 'POST'
			url: '/update-search-suburbs' # The update action in the buy controller (this is the route set in routes.rb)
			data: # The Params accessed via params[name]
				_method: 'PUT' # Used to tell Rails it's a PUT method for browsers that don't support PUT
				selected_state: state # The selected State value i.e. 'Queensland', needs to be long text value not 'QLD'
			success: (response) ->
				# Update the default text as it has been cleared (the options are already there on a success call, they were updated via
				# update_search_suburbs.js.erb)
				$('#search-field').siblings('.default.text').text('Search by suburb, address or keyword;')
	#remove nav active class
	$('.main-nav a').removeClass('active')
	#add slick-carousel
	$(".favouritesSlide").slick(
		dots: true,
		speed: 800,
		infinite: true,
		autoplay: true,
		autoplaySpeed: 4000)
	#dot carousel, fix for when you click on a dot and its still focused/in an active state
	$(document).on 'click', '.slick-dots li button, .slick-prev, .slick-next, .slick-slide, .slick-current, .slick-active', (e) ->
		e.target.blur()
		
$(document).ready ready