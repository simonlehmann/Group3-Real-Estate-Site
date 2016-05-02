# Created by Erdal Erkilic
# 13/4/16
# This is all javascript realated to the contact page

# Moved into one ready function to be called across page load and document.ready as discussed on Slack
ready = ->
	$('.contact-container').form fields:
		firstName:
	    	identifier: 'first-name'
	    	rules: [ {
	      		type: 'empty'
	      		prompt: 'Please enter your first name'
	    	} ]
	  	lastName:
	    	identifier: 'last-name'
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
	
$(document).ready ready
$(document).on 'page:load', ready