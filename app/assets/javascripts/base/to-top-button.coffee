# #	Created: Tylden Horan with aid from http://html-tuts.com/back-to-top-button-jquery/
# #	Date 23/04/2016
# #
# #	The following jQuery is for the top of page button
ready = ->
	$(window).scroll ->
		if $(window).scrollTop() > 200
			$('a.back-to-top').fadeIn 'slow'
		else
	    	$('a.back-to-top').fadeOut 'slow'
		return
	$('a.back-to-top').click ->
		$('html, body').animate { scrollTop: 0 }, 700
		false

$(document).ready ready
$(document).on 'page:load', ready