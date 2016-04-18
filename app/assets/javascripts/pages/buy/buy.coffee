ready = ->
	#search dropdown
	$('.search-section .ui.dropdown').dropdown allowAdditions: true
	#remove nav active class
	$('.main-nav a').removeClass('active')
	
$(document).ready ready
$(document).on 'page:load', ready