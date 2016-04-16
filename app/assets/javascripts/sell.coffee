# Created: Daniel Swain
# Date: 05/04/2016
# 
# The following coffeescript are for all sales pages.
# 
# Todo:
# 	* When you open the change status modals it select the checkbox, but its not happening
# 	  i.e. if your listing has a Home Open status, then opening the edit modal should have home open checked, not auction.
# 	  
# Note:
# 	Any code in here that pertains to the status modals had to be replicated in the manage.js.erb file and if you modify the modal
# 	code here you need to do it in manage.js.erb as well.

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

	#--------- Modal Code -------- READ THE NOTE UNDER THIS LINE BEFORE MAKING BIG CHANGES
	# NOTE: The code from this function also has to be in manage.js.erb currently to trigger the modals for the last 5 modals [see app/assets/views/manage.js.erb])
	# 		This is because the success: callback function doesn't fire when there are no more pages to load and it doesn't 
	
	# Assign callbacks for each modal This is a function called by the infinite scroll and is also called once on page load.
	set_up_modal_actions = ->
		$('.manage-status.modal').each ->
			# Only run this if it hasn't been set up (to speed things up)
			if !$(this).hasClass('modal-configured')
				# Set the modal as being configured to stop this happening on this modal again
				$(this).addClass('modal-configured')

				# Set Modal trigger to the ribbon with the launch-modal-id id (see manage_property_card.html.erb)
				modal_id = $(this).attr('id')
				$(this).modal 'attach events', '#launch-modal-' + modal_id, 'show'

				# Assign date and time pickers to the modal objects, customise the defualts from above if you want to here
				# Container specifies the dom element to attach the picker to (needed here as the label fields are too small)
				# Date Time Picker selectors
				home_date = $('.manage-status.modal #home-date-' + modal_id)
				home_start = $('.manage-status.modal #home-start-time-' + modal_id)
				home_end = $('.manage-status.modal #home-end-time-' + modal_id)
				auction_date = $('.manage-status.modal #auction-date-' + modal_id)
				auction_start = $('.manage-status.modal #auction-start-time-' + modal_id)
				auction_end = $('.manage-status.modal #auction-end-time-' + modal_id)
				# The if checks are to stop it constantly adding date time pickers when the async load is complete.
				if !home_date.hasClass('picker-set')			
					home_date.addClass('picker-set')
					home_date.removeClass('no-picker-set')
					home_date.pickadate container: '.manage-status.modal #home-date-container-' + modal_id
				if !home_start.hasClass('picker-set')			
					home_start.addClass('picker-set')
					home_start.removeClass('no-picker-set')
					home_start.pickatime container: '.manage-status.modal #home-start-time-container-' + modal_id
				if !home_end.hasClass('picker-set')			
					home_end.addClass('picker-set')
					home_end.removeClass('no-picker-set')
					home_end.pickatime container: '.manage-status.modal #home-end-time-container-' + modal_id
				if !auction_date.hasClass('picker-set')			
					auction_date.addClass('picker-set')
					auction_date.removeClass('no-picker-set')
					auction_date.pickadate container: '.manage-status.modal #auction-date-container-' + modal_id
				if !auction_start.hasClass('picker-set')
					auction_start.addClass('picker-set')
					auction_start.removeClass('no-picker-set')
					auction_start.pickatime container: '.manage-status.modal #auction-start-time-container-' + modal_id
				if !auction_end.hasClass('picker-set')			
					auction_end.addClass('picker-set')
					auction_end.removeClass('no-picker-set')
					auction_end.pickatime container: '.manage-status.modal #auction-end-time-container-' + modal_id

				# Accordian trigger change
				$('.manage-status.modal .accordion').accordion selector: trigger: '.title'
				
				# Attach a trigger event to the checkbox radio's so that the accordion title and it's elements also triggers it.
				# Done as an each loop so it only attaches the event for the title and checkbox that are together.
				$('.manage-status.modal .title').each ->
					$(this).children('.checkbox').checkbox 'attach events', $(this)
					return
			return

	## Call the modal set up function once on page load
	set_up_modal_actions()

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
		success: ->
			# Add triggers on a successful page load.
			# This doesn't fire when the last pages loads for some reason which is why the set_up_modal_actions function is duplicated in manage.js.erb
			set_up_modal_actions()
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
