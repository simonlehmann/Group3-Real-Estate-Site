# Created: Daniel Swain
# Date: 05/04/2016
# 
# The following coffeescript are for all sales pages.
# 
# Todo:
# 	* Handle status modal saving
# 	  

# Function containing all javascript needed on page load
ready = ->
	#--------- Dropdown Code
	# Sort dropdown for manage page, combo action replaces previous elements text with selection from dropdown
	$('#manage-filter').dropdown action: 'combo'

	#--------- Sticky Code
	# make the manage property table header sticky, it sticks to the ui.cards which is the next element
	$('.manage-table-header.ui.sticky').sticky
		offset: 60
		context: '.ui.cards'	
	# Refresh the manage property table header sticky if the page contains sell as it was not getting sized correctly.
	if window.location.pathname.includes('sell')
		$('.ui.sticky').sticky 'refresh'

	#--------- Tab Code
	# Support tab's on the add_edit page
	$('.add-edit.tabular.menu .item').tab()

	#--------- Date Time Picker Configuration 
	# Configure the date/time pickers for the status modals.
	# Extend the DatePicker Defaults, which will apply to all date pickers
	$.extend $.fn.pickadate.defaults,
		firstDay: 1					# Set first day to Monday
		min: true					# Set min date to the current date
		format: 'dd/mm/yyyy'		# Set Display format to 08/04/2016 needs to match the data format
		showMonthsShort: true		# Show the months short (i.e. Dec)
	
	# Extend the TimePicker Defaults, which will apply to all time pickers
	$.extend $.fn.pickatime.defaults,
		format: 'h:i a'				# Set display format to 3:00 PM
		formatSubmit: 'HH:i'		# Set submitted format to 15:00
		hiddenName: true			# Use a hidden input field and submit the value from that using the name of the shown field
		interval: 15				# Set the time interval
		min: [
			8
			0
		]							# Set the minimum time (8 am)
		max: [
			17
			0
		]							# Set the maximum time (5 pm)

	#--------- Modal Code -------- 	
	# On click of the status ribbon, open the modal using the data for that status object
	# Done as an onclick function now to reduce page load time.
	@set_up_and_launch_modal = (ribbon_id) ->
		# Get the status and listing information from the calling ribbon
		listing_id = $('.sell-red-ribbon.manage-status.ribbon#launch-modal-' + ribbon_id).data('listing')
		status_label = $('.sell-red-ribbon.manage-status.ribbon#launch-modal-' + ribbon_id).data('label')
		date = $('.sell-red-ribbon.manage-status.ribbon#launch-modal-' + ribbon_id).data('date')
		start_time = $('.sell-red-ribbon.manage-status.ribbon#launch-modal-' + ribbon_id).data('start')
		end_time = $('.sell-red-ribbon.manage-status.ribbon#launch-modal-' + ribbon_id).data('end')

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
			when "Home Open"
				# Home Open: Set the checkbox to checked
				desired_modal.find('#home-open-title').find('.checkbox').checkbox 'set checked'
				# Set the date and time values and set the picker options
				home_date_picker.set 'select', date, format: 'dd/mm/yyyy'
				home_start_picker.set 'select', start_time, format: 'HH:i'
				home_end_picker.set 'min', start_time
				home_end_picker.set 'select', end_time, format: 'HH:i'				
				# Open the accordion to the correct panel
				desired_modal.find('.accordion').accordion 'open', 0
			when "Auction"
				# Auction: Set the checkbox to checked
				desired_modal.find('#auction-title').find('.checkbox').checkbox 'set checked'
				# Set the date and time values and set the picker options
				auction_date_picker.set 'select', date, format: 'dd/mm/yyyy'
				auction_start_picker.set 'select', start_time, format: 'HH:i'
				auction_end_picker.set 'min', start_time
				auction_end_picker.set 'select', end_time, format: 'HH:i'
				# Open the accordion to the correct panel
				desired_modal.find('.accordion').accordion 'open', 1
			when "Under Offer"
				# Under Offer: Set the checkbox to checked and open the accordion to the correct panel
				desired_modal.find('#under-offer-title').find('.checkbox').checkbox 'set checked'
				desired_modal.find('.accordion').accordion 'open', 2
			when "Sold"
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
				desired_modal.find('.accordion .title').removeClass("active")
				desired_modal.find('.accordion .content').removeClass("active")
				# Clear old values from pickers
				home_date_picker.clear()
				home_start_picker.clear()
				home_end_picker.clear()
				auction_date_picker.clear()
				auction_start_picker.clear()
				auction_end_picker.clear()
				# Reset the input values for all input fields
				desired_modal.find('input').val("")
				# Reset the end time minimum incase any 'on set' methods were triggered. 
				home_end_picker.set 'min', '8:00'
				auction_end_picker.set 'min', '8:00'

			# The save button was hit, lets handle the save action and then reset the modal
			onApprove: ->
				console.log 'Save whas hit for modal: ' + listing_id
		).modal 'show'

		return

	#--------- Infinite Scroll Code
	# Hanlde infinite scroll of manage properties cards table
	# Can experiment with different buffers (where the scroll is triggerd as a distance from the bottom of the window) by adding
	# buffer: XXX <- where XXX is the integer value from the screen bottom the loading will trigger from.
	# Default is 1000 (i.e. 1000px) and seems good enough.
	$('.infinite-table').infinitePages
		# Change the state of the pagination link on loading and error.
		loading: ->
			# Change the link text
			$(this).text 'Loading more listings...'
		error: ->
			# Change the link text
			$(this).text 'There was an error retrieving more listings, please try again'

	#--------- Add/Edit Page Code
	# Change the sell price type input fields based upon the dropdown selection
	# Define a function to change the form fields that are available based upon the price dropdown value and set them as required if they're active
	price_dropdown_selection_change = (value) ->
		if value == 'F'
			# Fixed Price
			$('#price-field-fixed').show()
			$('#price-field-fixed').addClass 'required'
			$('#price-field-max').hide()
			$('#price-field-min').hide()
			$('#price-field-max').removeClass 'required'
			$('#price-field-min').removeClass 'required'
		else if value == 'R'
			# Ranged Price
			console.log value
			$('#price-field-fixed').hide()
			$('#price-field-fixed').removeClass 'required'
			$('#price-field-max').show()
			$('#price-field-min').show()
			$('#price-field-max').addClass 'required'
			$('#price-field-min').addClass 'required'
	# Set what is displayed based upon the initial value
	price_dropdown_selection_change($('#add-edit-price-dropdown').val())
	# Set what is displayed based upon the selected value
	$('#add-edit-price-dropdown').change ->
		value = @value
		price_dropdown_selection_change(value)

	#--------- Custom Tag
	# Add tags to the selection field based upon the entered info in the add-edit-additional-tags-dropdown
	# Get the tag area, the tag type dropdown, the tag input value and the add button
	additional_tag_area = $('#add-edit-additional-tags')
	additional_tag_area.dropdown allowAdditions: true
	additional_dropdown = $('#add-edit-additional-tags-dropdown')
	additional_input = $('#add-edit-additional-tags-input')
	additional_button = $('#add-edit-additional-tags-button')
	# Add a click function to the add tag button
	additional_button.on 'click', ->
		# Get the input value and the dropdown selection
		value = additional_input.val()
		selection = additional_dropdown.children("option").filter(":selected").text()
		if value != ''
			# Add the tag to the tag area if the value isn't empty
			new_tag_value = value + "_" + selection
			new_tag_text = value + " " + selection
			# Add an option to the selection box with the new tag value and text
			additional_tag_area.html('<option value="' + new_tag_value + '">' + new_tag_text + '</option>')
			# Due to how Semantic works, a timeout/delay had to be added to get this to work, if there's errors try changing the value from 1 to a larger number
			setTimeout (->
				additional_tag_area.dropdown 'refresh' # Refresh the dropdown with the new data
				additional_tag_area.dropdown 'set selected', new_tag_value # Select the new option based upon it's value
			), 1
		else
			# Otherwise send an alert
			alert "No value entered, please try again"

	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready
