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
	$('.search-section .ui.dropdown').dropdown fullTextSearch: true

	#fix for semantic remove text when suburb is selected and user has typed in some text and clicked on suburb by mouse :D
	$('#search-input-buy input').change ->
		$(this).val('')
	
	# Update the search dropdown options based upon the choice of state when it's changed via an ajax call
	$('#search-state-field').change ->
		# Get the state 
		state = $('#search-state-field :selected').val()
		# Clear the old data from the search dropdown
		$('#search-field').empty()
		$('#search-field').dropdown 'clear'
		changeImage(state)
		$(window).on 'load', ->
			console.log 'loading'
			remove_classes(state)
			return
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
				$('#search-field').siblings('.default.text').text('Search by suburbs;')

	
	#when the search button is clicked search is changed to loading icon
	$('#buy-search-submit').click( ->
		$('.search-action').text('')
		$('.search-action').html("<i class='loading sun icon search-loading'></i>"))
	
	#remove nav active class
	$('.main-nav a').removeClass('active')
	
	#add slick-carousel
	$(".favouritesSlide").slick(
		slidesToShow: 4,
		slidesToScroll: 1,
		dots: true,
		speed: 800,
		infinite: true,
		autoplay: true,
		autoplaySpeed: 4000,
		responsive: [
			{
				breakpoint: 693,
				settings:
					slidesToShow: 1,
					slidesToScroll: 1
			},
			{
				breakpoint: 893,
				settings:
					slidesToShow: 2,
					slidesToScroll: 2
			},
			{
				breakpoint: 1093,
				settings:
					slidesToShow: 3,
					slidesToScroll: 3
			},
			{
				breakpoint: 1293,
				settings:
					slidesToShow: 4,
					slidesToScroll: 4
			}])
	
	#dot carousel, fix for when you click on a dot and its still focused/in an active state
	$(document).on 'click', '.slick-dots li button, .slick-prev, .slick-next, .slick-slide, .slick-current, .slick-active', (e) ->
		e.target.blur()

	myTag = $('.truncate').text()
	if myTag.length > 15
		truncated = myTag.trim().substring(0, 50) + '…'
		$('.truncate').text truncated

	#checkWidth of page
	checkWidth = ->
		windowsize = $(window).width()
		#if page width is 440px show only 1 favourites on slide
		if windowsize < 693
			$('.favouritesSlide').addClass('slide-1')
			$('.favouritesSlide').removeClass('slide-2 slide-3 slide-4')
			return
		#if page width is 650px show only 2 favourites on slide
		else if windowsize < 893
			$('.favouritesSlide').addClass('slide-2')
			$('.favouritesSlide').removeClass('slide-1 slide-3 slide-4')
			return
		else if windowsize < 1093
			$('.favouritesSlide').addClass('slide-3')
			$('.favouritesSlide').removeClass('slide-1 slide-2 slide-4')
			return
		else
			$('.favouritesSlide').addClass('slide-4')
			$('.favouritesSlide').removeClass('slide-1 slide-2 slide-3')
	#When page is loaded
	checkWidth()
	#Event listener
	$(window).resize(checkWidth)
		
$(document).ready ready