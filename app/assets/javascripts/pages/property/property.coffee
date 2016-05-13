# Created: Jayden Spencer
# Date: 30/04/2016
# 
# The following coffeescript is for the property page
# 
# TODO:
#
ready = ->
	#add slick-carousel
	$(".propertySlide").slick(
		dots: true,
		speed: 1200,
		infinite: true,
		autoplay: true,
		autoplaySpeed: 4000)
	#add slick-lightbox
	$('.property-slick-slide').slickLightbox(
		itemSelector: '> a')
# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
