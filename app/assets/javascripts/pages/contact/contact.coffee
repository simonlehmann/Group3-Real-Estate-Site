# Created by Erdal Erkilic
# 13/4/16
# This is all javascript realated to the contact page

# Moved into one ready function to be called across page load and document.ready as discussed on Slack
ready = ->
	$('.ui.form').form fields:
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
	      		type: 'regExp[/^[A-z0-9._%+-]+@[A-z0-9.-]+\.[A-z]{2,}$/]',
	      		prompt: 'Please write your email to us'
	    	} ]
$(document).ready ready
$(document).on 'page:load', ready