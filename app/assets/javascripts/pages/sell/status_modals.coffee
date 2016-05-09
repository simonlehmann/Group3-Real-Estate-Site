#   Created: Daniel Swain
#   Date: 18/04/2016
# 
#   The following coffeescript is for the sales status modals
# 
#   Todo:
#   	* Handle status modal saving

# Function containing all javascript needed on page load
ready = ->
	#--------- Modal Code --------	
	# On click of the status ribbon, open the modal using the data for that status object
	# Done as an onclick function now to reduce page load time.
	@set_up_and_launch_modal = (ribbon_id) ->
		# Get the status and listing information from the calling ribbon
		listing_id = $('#launch-modal-' + ribbon_id).data('listing')
		status_label = $('#launch-modal-' + ribbon_id).data('label')
		date = $('#launch-modal-' + ribbon_id).data('date')
		start_time = $('#launch-modal-' + ribbon_id).data('start')
		end_time = $('#launch-modal-' + ribbon_id).data('end')

		# Get reference to the pertinent modal
		desired_modal = $('.manage-status.modal#' + listing_id)

		# Add listeners to the modal title to tick the checkboxes
		desired_modal.find('.title').each ->
			$(this).find('.checkbox').checkbox 'attach events', $(this)
			return
		
		# Accordian trigger change
		desired_modal.find('.accordion').accordion selector: trigger: '.title'

		# Assign date pickers and get the picker objects
		home_date = desired_modal.find('#home-date-' + listing_id).pickadate container: desired_modal.find('#home-date-container-' + listing_id)
		home_start_time = desired_modal.find('#home-start-time-' + listing_id).pickatime container: desired_modal.find('#home-start-time-container-' + listing_id)
		home_end_time = desired_modal.find('#home-end-time-' + listing_id).pickatime container: desired_modal.find('#home-end-time-container-' + listing_id)
		auction_date = desired_modal.find('#auction-date-' + listing_id).pickadate container: desired_modal.find('#auction-date-container-' + listing_id)
		auction_start_time = desired_modal.find('#auction-start-time-' + listing_id).pickatime container: desired_modal.find('#auction-start-time-container-' + listing_id)
		auction_end_time = desired_modal.find('#auction-end-time-' + listing_id).pickatime container: desired_modal.find('#auction-end-time-container-' + listing_id)
		# Get the picker objects
		home_date_picker = home_date.pickadate('picker')
		home_start_picker = home_start_time.pickatime('picker')
		home_end_picker = home_end_time.pickatime('picker')
		auction_date_picker = auction_date.pickadate('picker')
		auction_start_picker = auction_start_time.pickatime('picker')
		auction_end_picker = auction_end_time.pickatime('picker')
		# Set an on set listener for the home start time picker so that the home end time picker has it's min (or start time) set to the chosen start time
		# i.e. you can't select an ending time before the start time.
		home_start_picker.on set: (thingSet) ->
			set_value = home_start_picker.get 'value'
			home_end_picker.set 'min', set_value
			home_end_picker.set 'view', set_value
			return
		# Do the same for the auction start time picker
		auction_start_picker.on set: (thingSet) ->
			set_value = auction_start_picker.get 'value'
			auction_end_picker.set 'min', set_value
			auction_end_picker.set 'view', set_value
			return

		# Set the initial values based upon the status object
		switch status_label
			when 'Home Open'
				# Home Open: Set the checkbox to checked
				desired_modal.find('#home-open-title').find('.checkbox').checkbox 'set checked'
				# Set the date and time values and set the picker options
				home_date_picker.set 'select', date, format: 'dd/mm/yyyy'
				home_start_picker.set 'select', start_time, format: 'HH:i'
				home_end_picker.set 'min', start_time
				home_end_picker.set 'select', end_time, format: 'HH:i'				
				# Open the accordion to the correct panel
				desired_modal.find('.accordion').accordion 'open', 0
			when 'Auction'
				# Auction: Set the checkbox to checked
				desired_modal.find('#auction-title').find('.checkbox').checkbox 'set checked'
				# Set the date and time values and set the picker options
				auction_date_picker.set 'select', date, format: 'dd/mm/yyyy'
				auction_start_picker.set 'select', start_time, format: 'HH:i'
				auction_end_picker.set 'min', start_time
				auction_end_picker.set 'select', end_time, format: 'HH:i'
				# Open the accordion to the correct panel
				desired_modal.find('.accordion').accordion 'open', 1
			when 'Under Offer'
				# Under Offer: Set the checkbox to checked and open the accordion to the correct panel
				desired_modal.find('#under-offer-title').find('.checkbox').checkbox 'set checked'
				desired_modal.find('.accordion').accordion 'open', 2
			when 'Sold'
				# Sold: Set the checkbox to checked and open the accordion to the correct panel
				desired_modal.find('#sold-title').find('.checkbox').checkbox 'set checked'
				desired_modal.find('.accordion').accordion 'open', 3
			else
				# Remove Status: Set the checkbox to checked and open the accordion to the correct panel
				desired_modal.find('#remove-status-title').find('.checkbox').checkbox 'set checked'
				desired_modal.find('.accordion').accordion 'open', 4

		# Set callbacks and launch the modal
		desired_modal.modal(
			# Set the automatic focus to off (so it doesn't select the first input field and open up the pickers) and show it
			autofocus: false
			# The cancel button was hit. Lets clear the modal back to a blank state
			onDeny: ->
				# Reset title and content classes so they are not still open when you launch the modal again
				desired_modal.find('.accordion .title').removeClass('active')
				desired_modal.find('.accordion .content').removeClass('active')
				# Clear old values from pickers
				home_date_picker.clear()
				home_start_picker.clear()
				home_end_picker.clear()
				auction_date_picker.clear()
				auction_start_picker.clear()
				auction_end_picker.clear()
				# Reset the input values for all input fields
				desired_modal.find('input').val('')
				# Reset the end time minimum incase any 'on set' methods were triggered. 
				home_end_picker.set 'min', '8:00'
				auction_end_picker.set 'min', '8:00'

			# The save button was hit, lets handle the save action and then reset the modal
			# This expects the approve/save button to have the class 'approve' 
			onApprove: ->
				# Get the status information from the active accordion
				active_title = desired_modal.find('.accordion .title.active')
				listing_status_label = ''
				listing_status_date = ''
				listing_status_start_time = ''
				listing_status_end_time = ''
				# Now, grab the required data for saving the latest status
				switch active_title.attr('id')
					when 'home-open-title'
						listing_status_label = 'Home Open'
						listing_status_date = desired_modal.find('#home-date-' + listing_id).val()
						listing_status_start_time = desired_modal.find('#home-start-time-' + listing_id).val()
						listing_status_end_time = desired_modal.find('#home-end-time-' + listing_id).val()
					when 'auction-title'
						listing_status_label = 'Auction'
						listing_status_date = desired_modal.find('#auction-date-' + listing_id).val()
						listing_status_start_time = desired_modal.find('#auction-start-time-' + listing_id).val()
						listing_status_end_time = desired_modal.find('#auction-end-time-' + listing_id).val()
					when 'under-offer-title'
						listing_status_label = 'Under Offer'
					when 'sold-title'
						listing_status_label = 'Sold'
					when 'remove-status-title'
						listing_status_label = 'None'

				# Now we have all the information we need lets clear it all before the save (therefor resetting the modal)
				# Reset title and content classes so they are not still open when you launch the modal again
				desired_modal.find('.accordion .title').removeClass('active')
				desired_modal.find('.accordion .content').removeClass('active')
				# Clear old values from pickers
				home_date_picker.clear()
				home_start_picker.clear()
				home_end_picker.clear()
				auction_date_picker.clear()
				auction_start_picker.clear()
				auction_end_picker.clear()
				# Reset the input values for all input fields
				desired_modal.find('input').val('')
				# Reset the end time minimum incase any 'on set' methods were triggered. 
				home_end_picker.set 'min', '8:00'
				auction_end_picker.set 'min', '8:00'

				# ---- Actually save the information
				# If the listing_status_label isn't blank then save with an ajax call to the /sell/:id/status url
				# This is defined in sell_controller as the update_status action.
				if listing_status_label != ''
					# Ajax save call to the /sell/:id/status url in the sell controller
					$.ajax
						type: 'POST'
						url: '/sell/' + listing_id + '/status'
						# The data we're sending through, we use _method to handle browser that don't support 'PUT'
						data:
							_method: 'PUT'
							listing_status_label: listing_status_label
							listing_status_date: listing_status_date
							listing_status_start_time: listing_status_start_time
							listing_status_end_time: listing_status_end_time
						success: (response) ->
							# Use the successful response string to update the status ribbon
							# Remove the quotes and new line charactersfrom the response
							response = response.replace(/(\r\n|\n|\r)|["]/g,'')
							# split the response by the '|' character (giving us 6 elements)
							arr = response.split('|')
							# Update the status ribbon data attributes with the split values from the server
							ribbon = $('#launch-modal-' + arr[0])
							ribbon.data('label', arr[1]) # The status type (i.e. Home Open, Auction...)
							ribbon.data('date', arr[2]) # The date
							ribbon.data('start', arr[3]) # The start_time
							ribbon.data('end', arr[4]) # The end_time
							ribbon.find('.ribbon-text').text(arr[5]) # Update the ribbon text using the readable value
							return
					return

		).modal 'show'

		return

	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready
