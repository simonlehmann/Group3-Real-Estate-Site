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
	      		type: 'doesntContain[a][b]'
	      		prompt: 'Please write your email to us'
	    	} ]
	validateEmail = (email) ->
		re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
		re.test email

	validate = ->
	  $('#result').text ''
	  email = $('#email').val()
	  if validateEmail(email)
	    $('#result').text email + ' is valid :)'
	    $('#result').css 'color', 'green'
	  else
	    $('#result').text email + 'is not valid :('
	    $('#result').css 'color', 'red'
	  false
$(document).ready ready
$(document).on 'page:load', ready