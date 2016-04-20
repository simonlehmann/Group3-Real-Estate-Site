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
			user_modal.find('#user-sign-up-button').addClass('active-choice')
			user_modal.find('#user-login-button').removeClass('active-choice')
		else
			user_modal.find('#user-sign-up-button').removeClass('active-choice')
			user_modal.find('#user-login-button').addClass('active-choice')
		user_modal.modal(
			# Callback actions
			onDeny: ->
				console.log 'Cancel was hit'

			onApprove: ->
				console.log 'Submit was hit'

		).modal 'show'

	# Show the user-login modal on click -> focusing on the sign-in action
	$('.user-login').click ->
		show_modal(false)
		return

	# Show the user-login modal on click -> focusing on the sign-up action
	$('.user-signup').click ->
		show_modal()
		return

	
		
	# desired_modal.modal(
	# 	# Set the automatic focus to off (so it doesn't select the first input field and open up the pickers) and show it
	# 	autofocus: false
	# 	# The cancel button was hit. Lets clear the modal back to a blank state
	# 	onDeny: ->
	# 		# Reset title and content classes so they are not still open when you launch the modal again
	# 		desired_modal.find('.accordion .title').removeClass("active")
	# 		desired_modal.find('.accordion .content').removeClass("active")
	# 		# Clear old values from pickers
	# 		home_date_picker.clear()
	# 		home_start_picker.clear()
	# 		home_end_picker.clear()
	# 		auction_date_picker.clear()
	# 		auction_start_picker.clear()
	# 		auction_end_picker.clear()
	# 		# Reset the input values for all input fields
	# 		desired_modal.find('input').val("")
	# 		# Reset the end time minimum incase any 'on set' methods were triggered. 
	# 		home_end_picker.set 'min', '8:00'
	# 		auction_end_picker.set 'min', '8:00'

	# 	# The save button was hit, lets handle the save action and then reset the modal
	# 	onApprove: ->
	# 		console.log 'Save whas hit for modal: ' + listing_id
	# ).modal 'show'

	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready
