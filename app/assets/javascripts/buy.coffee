#TODO move location add remove header class in a main file
nav_delay = true
ready = ->
	#search dropdown
	$('.ui.dropdown').dropdown allowAdditions: true
	#remove nav active class
	$('.main-nav a').removeClass('active')
	#get page location
	loc = window.location.href
	console.log loc
	#switch between buy, sell activity header classes
	if loc.includes('buy')
		nav_delay = true
		$('header').addClass 'nav-buy'
		$('header').removeClass 'nav-sell'
		$('header').removeClass 'nav-dashboard'
		$('.main-nav a.buy-item').addClass('active')
	else if loc.includes('sell')
		nav_delay = false
		$('header').addClass 'nav-sell'
		$('header').removeClass 'nav-buy'
		$('header').removeClass 'nav-dashboard'
		$('.main-nav a.sell-item').addClass('active')
	else
		nav_delay = false
		$('header').removeClass 'nav-buy'
		$('header').removeClass 'nav-sell'
		$('header').removeClass 'nav-dashboard'
	#some pages dont need a delay in scroll, if thats the case add colour in back of nav
	if nav_delay == false
		$('header').addClass 'nav-fixed'
#scroll delay nav follows after a durtion with header images
$(window).bind 'scroll', ->
	if nav_delay == true and $(window).scrollTop() > 200
		$('header').addClass 'nav-fixed'
	else if nav_delay == false and $(window).scrollTop() >= 0
		$('header').addClass 'nav-fixed'
	else
		$('header').removeClass 'nav-fixed'
$(document).ready ready
$(document).on 'page:load', ready