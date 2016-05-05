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
	$('.add-edit-postcode.dropdown').dropdown()
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
			# Show the min field for fixed price, but change the label
			$('#price-field-min').show()
			$('#price-field-min label').text 'Price'
			# Hide the max price field and set it's input field value to the minimum value
			$('#price-field-max').hide()
			$('#price-field-max-input').val($('#price-field-min-input').val())
			# Handle the classes
			$('#price-field-min').addClass 'required'
			$('#price-field-max').removeClass 'required'
		else if value == 'R'
			# Ranged Price
			# Show the min and max fields
			$('#price-field-min').show()
			$('#price-field-max').show()
			# Change the min field label text
			$('#price-field-min label').text 'Minimum'
			# Handle the classes
			$('#price-field-min').addClass 'required'
			$('#price-field-max').addClass 'required'
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
		# Get the input quantity and the dropdown selection text and value
		qty = additional_input.val()
		# The value field has the tag_type_category as well (needed for the database saving), 
		# where as the text of the option choice is only the tag_type_label (which we want to display)
		value = additional_dropdown.children("option").filter(":selected").val()
		selection = additional_dropdown.children("option").filter(":selected").text()
		if value != "" and selection != "" and qty != ""
			# Add the tag to the tag area if the value isn't empty
			new_tag_value = qty + "_" + value
			# Store the display value as a singledton if only 1 qty was picked (i.e. 1 Pool = Pool)
			# Else, call the @get_plural(string) function located in global.coffee
			new_tag_text = if qty > 1 then get_plural(selection) else selection
			# Create an option tag
			opt = document.createElement('option')
			opt.value = new_tag_value
			opt.innerHTML = new_tag_text
			console.log opt
			# Add the option to the selection box with the new tag value and text (whilst keeping the old values (this used to override the selections))
			additional_tag_area.append(opt)
			# Due to how Semantic works, a timeout/delay had to be added to get this to work, if there's errors try changing the value from 1 to a larger number
			setTimeout (->
				additional_tag_area.dropdown 'refresh' # Refresh the dropdown with the new data
				additional_tag_area.dropdown 'set selected', new_tag_value # Select the new option based upon it's value
			), 1
			# Reset the additional tag dropdowns to their initial selected values and placeholder text
			additional_input.dropdown 'clear'
			additional_dropdown.dropdown 'clear'
			additional_input.dropdown 'set text', 'Enter Qty For Additional Feature'
			additional_dropdown.dropdown 'set text', 'Additional Feature'
		else
			# Otherwise send an alert
			alert 'Please select an additional feature and quantity and try again'

	# Refresh the addition tag dropdown selector field incase we're editing an exisitng listing which has tags
	# (the server will set them selected, but Semantic, needs to add the tags)
	additional_tag_area.find('option').each (i) ->
		# If it's not the placeholder option and options existing on page load then they're from the server and need to be set selected
		if $(this).val() != ''
			additional_tag_area.dropdown 'set selected', $(this).val()
		return
	
	# Change the suburb/postcode dropdown options based on the selected state
	$('#listing_listing_state').change ->
		# Get the state and the listing id (needed to dynamically update the suburb/postcode dropdowns)
		state = $('#listing_listing_state :selected').text()
		listing_id = $('#listing_listing_state').data('id')
		# Clear the old data from the dropdowns
		$('#listing_listing_suburb').dropdown 'clear'
		$('#listing_listing_post_code').dropdown 'clear'
		# Update the dropdowns via an Ajax call to the server
		$.ajax
			type: 'POST'
			url: '/sell/' + listing_id + '/suburbs'
			data:
				_method: 'PUT'
				listing_state: state
			success: (response) ->
				# Clear the default first item selection and update the default text
				$('#listing_listing_suburb').dropdown 'clear'
				$('#listing_listing_post_code').dropdown 'clear'
				$('#listing_listing_suburb').siblings('.default.text').text('Select Suburb')
				$('#listing_listing_post_code').siblings('.default.text').text('Select Postcode')

	# Change the postcode dropdown options based upon the selected state and suburb
	$('#listing_listing_suburb').change ->
		# Get the state and listing id
		state = $('#listing_listing_state :selected').text()
		suburb = $('#listing_listing_suburb :selected').text()
		listing_id = $('#listing_listing_state').data('id')
		# State and suburb are selected so lets update the postcode
		if state != '' and state != 'Select State' and suburb != '' and suburb != 'Select Suburb'
			$('#listing_listing_post_code').dropdown 'clear'
			# Update the postcode based upon the selected options
			$.ajax
				type: 'POST'
				url: '/sell/' + listing_id + '/postcodes'
				data:
					_method: 'PUT'
					listing_state: state
					listing_suburb: suburb
				success: (response) ->
					# Clear the default first item selection and update the default text
					$('#listing_listing_post_code').dropdown 'clear'
					$('#listing_listing_post_code').siblings('.default.text').text('Select Postcode')

	# Form validation rules
	validation_rules = 
		address: # Can't be empty
			identifier: 'listing[listing_address]'
			rules: [{
				type: 'empty'
				prompt: 'Please enter a street address'
			}]
		state: # Can't be empty
			identifier: 'listing[listing_state]'
			rules: [{
				type: 'empty'
				prompt: 'Please select a state'
			}]
		suburb: # Can't be empty
			identifier: 'listing[listing_suburb]'
			rules: [{
				type: 'empty'
				prompt: 'Please select a suburb'
			}]
		postcode: # Can't be empty
			identifier: 'listing[listing_post_code]'
			rules: [{
				type: 'empty'
				prompt: 'Please select a postcode'
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
		# If we've changed the selector for the price type and we've updated the fixed price value then we need to store it in the max field as well
		if $('#add-edit-price-dropdown').val() == 'F'
			# We need to change it here when saving as you might have changed it after selecting fixed price (so min and max won't line up anymore)
			$('#price-field-max-input').val($('#price-field-min-input').val())
		# Submit the form
		$('#add-edit-listing-form').form 'submit'
		return

	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready
