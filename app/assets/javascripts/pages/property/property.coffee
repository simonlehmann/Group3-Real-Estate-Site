# Created: Jayden Spencer
# Date: 30/04/2016
# 
# The following coffeescript is for the property page
# 
# TODO:
#
ready = ->
	if $('.more-description').length
		description_height = $('.description-area')[0].scrollHeight
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

	#more description button click
	$('.more-description').click (e) ->
		if $(this).hasClass('description-expand')
			$('.description-area').animate 'height': '255px'
			$(this).removeClass('description-expand')
			$(this).children('i').removeClass('chevron up icon')
			$(this).children('i').addClass('chevron down icon')
			$(this).children('span').text('Show More')
		else
			$('.description-area').animate 'height': description_height
			$(this).addClass('description-expand')
			$(this).children('i').removeClass('chevron down icon')
			$(this).children('i').addClass('chevron up icon')
			$(this).children('span').text('Show Less')
	$('.map-buttons #distance-dropdown').dropdown()

	

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready