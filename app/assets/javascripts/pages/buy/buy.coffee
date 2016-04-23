ready = ->
	#search dropdown
	$('.search-section .ui.dropdown').dropdown allowAdditions: true
	#remove nav active class
	$('.main-nav a').removeClass('active')
	#add slick-carousel
	$(".favouritesSlide").slick(
		dots: true,
		speed: 150,
		infinite: true,
		autoplay: true,
		autoplaySpeed: 10000)
	
$(document).ready ready
$(document).on 'page:load', ready