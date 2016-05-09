#   Created: Daniel Swain
#   Date: 20/04/2016
# 
#   The following coffeescript is for the user login/signup functionality
# 
#   Todo:

# Function containing all javascript needed on page load
ready = ->

	# --------- FACEBOOK JQUERY DEVELOPMENT KIT (WILL BE USED FOR USER LOGIN BY FACEBOOK BUTTON)
	# $.ajaxSetup cache: true
	# $.getScript '//connect.facebook.net/en_US/sdk.js', ->
	# 	FB.init
	# 		appId: '{your-app-id}'
	# 		version: 'v2.5'
	# 	$('#loginbutton,#feedbutton').removeAttr 'disabled'
	# 	FB.getLoginStatus updateStatusCallback
	# 	return

	# --------- GOOGLE SIGNIN
	# Example onSignIn function for Google Sign in
	# onSignIn = (googleUser) ->
	# 	profile = googleUser.getBasicProfile()
	# 	console.log('Full Name: ' + profile.getName())
	# 	return

	# Set up and show the modal
	# Set callbacks and launch the modal
	show_modal = (sign_up = true) ->
		# Get the modal selector
		user_modal = $('#user-login-signup-modal')
		# Add classes and set up modal based upon whether you clicked login or join (aka sign_up)
		if sign_up == true
			# Select the correct button
			user_modal.find('#user-sign-up-button').addClass('active-choice')
			user_modal.find('#user-login-button').removeClass('active-choice')
			# Change the text in all the buttons and actions
			user_modal.find('.user-action').text('Sign Up')
			# Show the correct form
			user_modal.find('#user-sign-up-form').show()
			user_modal.find('#user-login-form').hide()
			# Change the modal header
			user_modal.find('#user-login-signup-modal-header').text('Welcome to Propertydome!')
		else
			# Select the correct button
			user_modal.find('#user-sign-up-button').removeClass('active-choice')
			user_modal.find('#user-login-button').addClass('active-choice')
			# Change the text in all the buttons
			user_modal.find('.user-action').text('Login')
			# Show the correct form
			user_modal.find('#user-sign-up-form').hide()
			user_modal.find('#user-login-form').show()
			# Change the modal header
			user_modal.find('#user-login-signup-modal-header').text('Welcome Back!')
			
		# Make the sign-up button change modal state
		user_modal.find('#user-sign-up-button').click ->
			if !$(this).hasClass('active-choice')
				# Change the text in all the buttons and actions
				user_modal.find('.user-action').text('Sign Up')
				# Change the classes
				user_modal.find('#user-sign-up-button').addClass('active-choice')
				user_modal.find('#user-login-button').removeClass('active-choice')
				# Show the correct form
				user_modal.find('#user-sign-up-form').show()
				user_modal.find('#user-login-form').hide()
				# Change the modal header
				user_modal.find('#user-login-signup-modal-header').text('Welcome to Propertydome!')
			return

		# Make the login button change modal state
		user_modal.find('#user-login-button').click ->
			if !$(this).hasClass('active-choice')
				# Change the text in all the buttons and actions
				user_modal.find('.user-action').text('Login')
				# Change the classes
				user_modal.find('#user-sign-up-button').removeClass('active-choice')
				user_modal.find('#user-login-button').addClass('active-choice')
				# Show the correct form
				user_modal.find('#user-sign-up-form').hide()
				user_modal.find('#user-login-form').show()
				# Change the modal header
				user_modal.find('#user-login-signup-modal-header').text('Welcome Back!')
			return

		# Set the modal width
		user_modal.css('width', 300)

		# Set callback actions and show it
		user_modal.modal(
			onHide: ->
				# Clear the input fields when it's closed
				user_modal.find('#user-sign-up-form .field input').val("")
				user_modal.find('#user-login-form .field input').val("")
		).modal 'show'

		

	# Show the user-login modal on click -> focusing on the sign-in action
	$('.user-login').click ->
		show_modal(false)
		return

	# Show the user-login modal on click -> focusing on the sign-up action
	$('.user-signup').click ->
		show_modal()
		return

	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready
