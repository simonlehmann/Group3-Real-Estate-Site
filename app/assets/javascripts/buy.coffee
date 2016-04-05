#TODO move location add remove header class in a main file
$(document).ready ->
	loc = window.location.href
	console.log loc
	switch loc.includes
		when 'buy' || 'search'
			$('header').addClass('nav-buy')
			$('header').removeClass('nav-sell')
			$('header').removeClass('nav-dashboard')
		when 'sell'
			$('header').addClass('nav-sell')
			$('header').removeClass('nav-buy')
			$('header').removeClass('nav-dashboard')
		else
			$('header').addClass('nav-buy')
			$('header').removeClass('nav-sell')
			$('header').removeClass('nav-dashboard')
$(window).bind 'scroll', ->
	if $(window).scrollTop() > 200
		$('header').addClass 'nav-fixed'
	else
		$('header').removeClass 'nav-fixed'