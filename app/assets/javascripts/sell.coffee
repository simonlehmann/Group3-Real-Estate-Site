# Created: Daniel Swain
# Date: 05/04/2016
# 
# The following coffeescript are for all sales pages.

# Function containing all javascript needed on page load
ready = ->
	# Sort dropdown for manage page, combo action replaces previous elements text with selection from dropdown
	$('#manage-filter').dropdown action: 'combo'
	# make the manage property table header sticky, it sticks to the ui.cards which is the next element
	console.log(window.location.pathname)
	$('.ui.sticky').sticky
		offset: 60
		context: '.ui.cards'	
	
	# Refresh the manage property table header sticky if the page contains sell as it was not getting sized correctly.
	if window.location.pathname.includes('sell')
		$('.ui.sticky').sticky 'refresh'

	# Support tab's on the add_edit page
	$('.add-edit.tabular.menu .item').tab()

	# Status modal on manage page code
	# Launch the modal
	$('.manage-status.modal').modal 'attach events', '.manage-status.ribbon', 'show'
	# Accordian trigger change
	$('.manage-status.modal .accordion').accordion selector: trigger: '.title'
	# Attach a trigger event to the checkbox radio's so that the checkbox label also triggers it.
	$('.manage-status.modal .checkbox').checkbox 'attach events', $('.manage-status.modal .checkbox label')
	# Attach a trigger event to the checkbox radio's so that the accordion title also triggers it.
	# Done as an each loop so it only attaches the event for the title and checkbox that are together.
	$('.manage-status.modal .title').each ->
		$(this).children('.checkbox').checkbox 'attach events', $(this)
		return

	# Configure the date/time pickers for the status modals.
	# Extend the DatePicker Defaults, which will apply to all date pickers
	$.extend $.fn.pickadate.defaults,
		firstDay: 1					# Set first day to Monday
		min: true					# Set min date to the current date
		format: 'd mmm, yyyy'		# Set Display format to 8 Apr, 2016
		formatSubmit: 'dd/mm/yyyy'	# Set Submit format to 08/04/2016
		hiddenName: true			# Use a hidden input field and submit the value from that using the name of the shown field
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
	
	# Assign date and time pickers to the modal objects, customise the defualts from above if you want to here
	# Container specifies the dom element to attach the picker to (needed here as the label fields are too small)
	$('.manage-status.modal input[name="home-date"]').pickadate container: '.manage-status.modal #home-date-container'
	$('.manage-status.modal input[name="home-start-time"]').pickatime container: '.manage-status.modal #home-start-time-container'
	$('.manage-status.modal input[name="home-end-time"]').pickatime container: '.manage-status.modal #home-end-time-container'
	$('.manage-status.modal input[name="auction-date"]').pickadate container: '.manage-status.modal #auction-date-container'
	$('.manage-status.modal input[name="auction-start-time"]').pickatime container: '.manage-status.modal #auction-start-time-container'
	$('.manage-status.modal input[name="auction-end-time"]').pickatime container: '.manage-status.modal #auction-end-time-container'

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

	# Hanlde infinite scroll of manage properties
	$('.infinite-table').infinitePages
		buffer: 100 # Auto scroll when 100px from bottom of window
		loading: ->
			$(this).text 'Loading next page...'
		error: ->
			$(this).text 'There was an error, please try again'

	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready