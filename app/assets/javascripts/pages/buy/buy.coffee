# Created: Jayden Spencer
# Date: 05/04/2016
# 
# The following coffeescript is for the index/buy page.
# 
# TODO:
# * Move lightbox to property page, when its time!
#
ready = ->
	#search dropdown
	$('.search-section .ui.dropdown').dropdown allowAdditions: true
	#remove nav active class
	$('.main-nav a').removeClass('active')
	#add slick-carousel
	$(".favouritesSlide").slick(
		dots: true,
		speed: 800,
		infinite: true,
		autoplay: true,
		autoplaySpeed: 4000)
	#add slick-lightbox
	$('.slick-slide').slickLightbox(
		itemSelector: '> a')
	#dot carousel, fix for when you click on a dot and its still focused/in an active state
	$(document).on 'click', '.slick-dots li button, .slick-prev, .slick-next', (e) ->
		e.target.blur()
	
$(document).ready ready
$(document).on 'page:load', ready