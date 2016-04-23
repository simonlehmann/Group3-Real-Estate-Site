nav_delay = true
ready = ->
	#get page location (changed from href to pathname to check for root url during testing. In prod will probably change back to href)
	loc = window.location.pathname
	console.log loc
	#switch between buy, sell activity header classes
		#for buy or root '/'
	if loc.includes('buy')
		nav_delay = true
		$('header').addClass 'nav-buy'
		$('header').removeClass 'nav-sell'
		$('header').removeClass 'nav-dashboard'
		$('#float-menu').addClass 'nav-buy'
		$('#float-menu').removeClass 'nav-sell'
		$('#float-menu').removeClass 'nav-dashboard'
		$('.main-nav a.buy-item').addClass 'active'
	else if loc.includes('sell')
		# Grab top sell element and see if it is the sell-banner (needs clear nav-menu with delay) or there's no banner
		if $('.sell-top').hasClass 'sell-banner'
			nav_delay = true
		else
			nav_delay = false
		$('header').addClass 'nav-sell'
		$('header').removeClass 'nav-buy'
		$('header').removeClass 'nav-dashboard'
		$('#float-menu').removeClass 'nav-buy'
		$('#float-menu').addClass 'nav-sell'
		$('#float-menu').removeClass 'nav-dashboard'
		$('.main-nav a.sell-item').addClass 'active'
	#dashboard
	else if loc.includes 'dashboard'
		nav_delay = false
		$('header').addClass 'nav-dashboard'
		$('header').removeClass 'nav-buy'
		$('header').removeClass 'nav-sell'
		$('#float-menu').removeClass 'nav-buy'
		$('#float-menu').removeClass 'nav-sell'
		$('#float-menu').addClass 'nav-dashboard'
		$('.main-nav a.activity-item').addClass 'active'
	# User sign-up/login pages to match the buy style, but with no delay
	else if loc == '/' or loc.includes('login') or loc.includes('password') or loc.includes('cancel') or loc.includes('sign_up') or loc.includes('edit')
		nav_delay = false
		$('header').addClass 'nav-buy'
		$('header').removeClass 'nav-sell'
		$('header').removeClass 'nav-dashboard'
	else
		nav_delay = false
		$('header').removeClass 'nav-buy'
		$('header').removeClass 'nav-sell'
		$('header').removeClass 'nav-dashboard'
	#some pages dont need a delay in scroll, if thats the case add colour in back of nav
	if nav_delay == false
		$('header').addClass 'nav-fixed'
#scroll delay nav follows after a durtion with header images
$(window).scroll ->
	if nav_delay == true and $(this).scrollTop() > 250
		$('#float-menu').fadeIn(300)
	else if nav_delay == false and $(this).scrollTop() >= 0
		$('#float-menu').fadeOut(200)
	else
		$('#float-menu').fadeOut(200)

$(document).ready ready
$(document).on 'page:load', ready