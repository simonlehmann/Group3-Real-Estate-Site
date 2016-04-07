#TODO move location add remove header class in a main file
ready = ->
	$('.ui.dropdown').dropdown allowAdditions: true
	
	loc = window.location.href
	console.log loc
	if loc.includes('buy')
		$('header').addClass 'nav-buy'
		$('header').removeClass 'nav-sell'
		$('header').removeClass 'nav-dashboard'
	else if loc.includes('sell')
		$('header').addClass 'nav-fixed'
		$('header').addClass 'nav-sell'
		$('header').removeClass 'nav-buy'
		$('header').removeClass 'nav-dashboard'
	else
		$('header').removeClass 'nav-buy'
		$('header').removeClass 'nav-sell'
		$('header').removeClass 'nav-dashboard'
$(window).bind 'scroll', ->
	if $(window).scrollTop() > 200
		$('header').addClass 'nav-fixed'
	else
		$('header').removeClass 'nav-fixed'
$(document).ready ready
$(document).on 'page:load', ready