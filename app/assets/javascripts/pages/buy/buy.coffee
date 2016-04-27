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
	$('.slick-slide').slickLightbox(
		itemSelector: '> a')
	
$(document).ready ready
$(document).on 'page:load', ready