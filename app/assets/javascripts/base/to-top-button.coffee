ready = ->
	# #	Created: Tylden Horan with aid from http://html-tuts.com/back-to-top-button-jquery/
	# #	Date 23/04/2016
	# #
	# #	The following jQuery is for the top of page button
	# $('body').prepend '<a href="#" class="back-to-top">Back to Top</a>'
	$(window).scroll ->
		if $(window).scrollTop() > 200
			$('a.back-to-top').fadeIn 'slow'
		else
	    	$('a.back-to-top').fadeOut 'slow'
		return
	$('a.back-to-top').click ->
		console.log 'Clicked!'
		$('html, body').animate { scrollTop: 0 }, 700
		false

$(document).ready ready
$(document).on 'page:load', ready