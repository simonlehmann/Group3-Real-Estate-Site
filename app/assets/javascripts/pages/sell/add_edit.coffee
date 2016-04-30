#   Created: Daniel Swain
#   Date: 18/04/2016
# 
#   The following coffeescript is for the sales add/edit page
# 
#   Todo:

# Function containing all javascript needed on page load
ready = ->
	#--------- Add/Edit Page Code
	# Support tab's on the add_edit page
	$('.add-edit.tabular.menu .item').tab()

	# Turn on the dropdowns on the add edit page
	$('.add-edit-suburb.dropdown').dropdown()
	$('.add-edit-state.dropdown').dropdown()
	$('.add-edit-price.dropdown').dropdown()
	$('.add-edit-additional-tags.dropdown').dropdown()
	$('.add-edit-additional-tags-input.dropdown').dropdown()

	# Dimmer on hover of the add/edit page add-new-picture card
	$('.add-new-picture.card .image').dimmer on: 'hover'

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

	# Custom Tags
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
		selection = additional_dropdown.children("option").filter(":selected").val()
		console.log value
		console.log selection
		if value != "" and selection != ""
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
			# Reset the additional tag dropdowns to their initial selected values and placeholder text
			additional_input.dropdown 'clear'
			additional_dropdown.dropdown 'clear'
			additional_input.dropdown 'set text', "Enter Qty For Additional Feature"
			additional_dropdown.dropdown 'set text', "Additional Feature"
		else
			# Otherwise send an alert
			alert "Please select an additional feature and quantity and try again"

	# Form validation rules
	validation_rules = 
		address: # Can't be empty
			identifier: 'listing[listing_address]'
			rules: [{
				type: 'empty'
				prompt: 'Please enter a street address'
			}]
		suburb: # Can't be empty
			identifier: 'listing[listing_suburb]'
			rules: [{
				type: 'empty'
				prompt: 'Please select a suburb'
			}]
		state: # Can't be empty
			identifier: 'listing[listing_state]'
			rules: [{
				type: 'empty'
				prompt: 'Please select a state'
			}]
		bedrooms: # Can't be empty
			identifier: 'listing[listing_bedrooms]'
			rules: [{
				type: 'empty'
				prompt: 'Please enter the number of bedrooms'
			}]
		bathrooms: # Can't be empty
			identifier: 'listing[listing_bathrooms]'
			rules: [{
				type: 'empty'
				prompt: 'Please enter the number of bathrooms'
			}]
		parking: # Can't be empty
			identifier: 'listing[listing_parking]'
			rules: [{
				type: 'empty'
				prompt: 'Please enter the number of parking spots'
			}]
		lot_size: # Can't be empty
			identifier: 'listing[listing_land_size]'
			rules: [{
				type: 'empty'
				prompt: 'Please enter the lot size'
			}]
		price_type: # Can't be empty
			identifier: 'listing[listing_price_type]'
			rules: [{
				type: 'empty'
				prompt: 'Please select a price type'
			}]
		price_min: # Can't be empty
			identifier: 'listing[listing_price_min]'
			rules: [{
				type: 'empty'
				prompt: 'Please enter a price'
			}]
		price_max: # Can't be empty
			identifier: 'listing[listing_price_max]'
			rules: [{
				type: 'empty'
				prompt: 'Please enter a maximum price'
			}]
		description: # Can't be empty
			identifier: 'listing[listing_description]'
			rules: [{
				type: 'empty'
				prompt: 'Please enter a description'
			}]
		title: # Can't be empty
			identifier: 'listing[listing_title]'
			rules: [{
				type: 'empty'
				prompt: 'Please enter a title'
			}]
		subtitle: # Can't be empty
			identifier: 'listing[listing_subtitle]'
			rules: [{
				type: 'empty'
				prompt: 'Please enter a subtitle'
			}]


	# Bind the rules to the form and set form options (the only way I found to get the errors was to set inline to true)
	$('#add-edit-listing-form').form
		inline: true
		fields: validation_rules

	# Submit the form using the action defined by the form itself. (As the button is outside of the form I need to call submit on it via javascript)
	$('#add-edit-submit-button').on 'click', ->
		$('#add-edit-listing-form').form 'submit'
		return

	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready
