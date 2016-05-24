# Created by Erdal Erkilic
# 13/4/16
# This is all javascript realated to the contact page

# Moved into one ready function to be called across page load and document.ready as discussed on Slack
ready = ->
	$('.contact-container .ui.form').form fields:
		firstName:
	    	identifier: 'first_name'
	    	rules: [ {
	      		type: 'empty'
	      		prompt: 'Please enter your first name'
	    	} ]
	  	lastName:
	    	identifier: 'last_name'
	    	rules: [ {
	     		type: 'empty'
	     		prompt: 'Please enter your last name'
	    	} ]
	  	message:
	    	identifier: 'message'
	    	rules: [ {
	      		type: 'empty'
	      		prompt: 'Please write your message to us'
	    	} ]
	    email:
	    	identifier: 'email'
	    	rules: [ {
	      		type: 'regExp[/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$/]',
	      		prompt: 'Please write your email to us'
	    	} ]

	$('#contact-type-selector').dropdown()

	$ ->
		p = 'callto'
		h = '61'
		o = '0425'
		n = '448'
		e = '555'
		$('p.phone').replaceWith '<a href=' + p + '://+' + h + o + n + e + ' class="link">(04) 25 448 555</a>'
		return

	$ ->
		p = 'mailto'
		h = 'PropertyDome'
		o = '@gmail.com'
		n = '?Subject='
		e = 'Hello%20again'
		$('p.email').replaceWith '<a href=' + p + ':' + h + o + n + e + ' class="link">PropertyDome@gmail.com</li>'
		return
	
$(document).ready ready
