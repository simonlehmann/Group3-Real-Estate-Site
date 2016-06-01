#   Created: Daniel Swain
#   Date: 18/04/2016
# 
#   The following coffeescript is for the sales add/edit page
#   
#   It contains all the js functions used on the add/edit page. including
#   	* Tab changing
#   	* Dropdown settings
#   	* Dropdown change evenets
#   	* Form validation rules
#   	* Form actions
#   	* Image upload code (preview, setting image as main image, marking for deletion)
# 
#   Todo:

# Function containing all javascript needed on page load
ready = ->
	#--------- Add/Edit Page Code
	# Support tab's on the add_edit page
	$('.add-edit.tabular.menu .item').tab()

	# Turn on the dropdowns on the add edit page, making the state, suburb and postcode search dropdowns support full text search
	$('.add-edit-type.dropdown').dropdown()
	$('.add-edit-state.dropdown').dropdown fullTextSearch: true
	$('.add-edit-suburb.dropdown').dropdown fullTextSearch: true
	$('.add-edit-postcode.dropdown').dropdown fullTextSearch: true
	$('.add-edit-price.dropdown').dropdown()
	$('.add-edit-additional-tags.dropdown').dropdown()
	$('.add-edit-additional-tags-input.dropdown').dropdown()

	# --------- FORM INPUT STATE CHANGE EVENTS
	#
	# ---- Price Type Change
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

	# ---- Custom Tags
	# Add tags to the selection field based upon the entered info in the add-edit-additional-tags-dropdown
	# Get the tag area, the tag type dropdown, the tag input value and the add button
	additional_tag_area = $('#add-edit-additional-tags')
	additional_tag_area.dropdown 
		allowAdditions: true
		# Event Callback so that on add to this dropdown, lets remove the corresponding choice from the additional_dropdown
		onAdd: (addedValue, addedText, $addedChoice) ->
			# Get the option value we want to remove from the additional_dropdown list
			split_vals = addedValue.split('_')
			# This is formatted ['qty', 'tag_type', 'tag_category'], lets remove the select option with the value of the tag_type + tag_category
			removing_value = split_vals[1] + '_' + split_vals[2]
			# Remove this value from the dropdown
			additional_dropdown.find('option[value="' + removing_value + '"]').remove()
			# Refresh the dropdown so it reflects the change (done after a short timeout due to a quirk with Semantic UI dropdowns)
			setTimeout (->
				additional_dropdown.dropdown 'refresh' 
			), 0.1
		# Event callback to add the tag back into the additional_dropdown as an option when a tag is removed
		onRemove: (removedValue, removedText, $removedChoice) ->
			# Get the option value we need to add back into the list
			split_vals = removedValue.split('_')
			# This is formatted ['qty', 'tag_type', 'tag_category'], lets remove the select option with the value of the tag_type + tag_category
			adding_value = split_vals[1] + '_' + split_vals[2]
			# check if this option already exists in the additional_dropdown as an option
			check_if_there = additional_dropdown.find('option[value="' + adding_value + '"]')
			# No option exists so lets add it to the additional_dropdown field
			if !check_if_there.length
				# Append the additional dropdown back to the list in alphabeticall order, but we want to stop once it's added
				option_added = false
				# Compare each option in the list and if it's added set option_added to true return false to exit the loop
				additional_dropdown.find('option').each ->
					if !option_added and $(this).text() > split_vals[1] and $(this).val != ""
						# I found that I had to add the option tag like this as it would fail if I passed an action option object
						$('<option value="' + adding_value + '">' + split_vals[1] + '</option>').insertBefore($(this))
						option_added = true
						return false # Exit the each loop early
				# If after the loop we haven't added it, lets add it in right at the end
				if !option_added
					$('<option value="' + adding_value + '">' + split_vals[1] + '</option>').appendTo(additional_dropdown)
				# Due to how Semantic works, a timeout/delay had to be added to get this to work, if there's errors try changing the value from 1 to a larger number
				setTimeout (->
					# Refresh the dropdown with the newly re-added option
					additional_dropdown.dropdown 'refresh' 
				), 0.1
				
	# Get the remaining dropdown and input fields
	additional_dropdown = $('#add-edit-additional-tags-dropdown')
	additional_dropdown.dropdown sortSelect: true # Sort the dropdown on creation from the select element
	additional_input = $('#add-edit-additional-tags-input')
	additional_button = $('#add-edit-additional-tags-button')

	# Limit the additional_input dropdown to be 1 for tags that can only have 1 qty
	additional_dropdown.on 'change', ->
		# Get the selection from the dropdown
		selection = additional_dropdown.find('option:selected').text()
		# If the selection is in the following list then disable the qty dropdown so it stays as 1
		switch selection
			# NB, need to lead with a ',' to prevent the new line causing an unexpected indentation in coffeescript
			when 'Airconditioning', 'Ducted Cooling', 'Ducted Heating', 'Evaporative AC', 'Gas Heating', 'Reverse Cycle', 'Split System'
			,	'Grey Water', 'Solar', 'Solar Hot Water', 'Pay TV', 'Satelite TV', 'Ocean Views', 'NBN', 'Established Home', 'New Home'
			,	'Pet Friendly', 'Wheelchair Access'
				# ADD the Semantic class 'disabled' to the div containing the dropdown class to disable it
				$('.add-edit-additional-tags-input.dropdown').addClass 'disabled'
			else
				# For the remaining selections mulitples are allowed so lets remove the Semantic class 'disabled' from the div containing the dropdown class to
				# re-enable it.
				$('.add-edit-additional-tags-input.dropdown').removeClass 'disabled'

	# Add a click function to the add tag button
	additional_button.on 'click', ->
		# Get the input quantity and the dropdown selection text and value
		qty = additional_input.val()
		# The value field has the tag_type_category as well (needed for the database saving), 
		# where as the text of the option choice is only the tag_type_label (which we want to display)
		value = additional_dropdown.find('option:selected').val()
		selection = additional_dropdown.find('option:selected').text()
		if value != "" and selection != "" and qty != ""
			# Add the tag to the tag area if the value isn't empty
			new_tag_value = qty + "_" + value
			# Store the display value as a singledton if only 1 qty was picked (i.e. 1 Pool = Pool)
			# Else, call the @get_plural(string) function located in global.coffee
			new_tag_text = if qty > 1 then qty + ' ' + get_plural(selection) else selection
			# Create an option tag
			opt = document.createElement('option')
			opt.value = new_tag_value
			opt.innerHTML = new_tag_text
			# Add the option to the selection box with the new tag value and text (whilst keeping the old values (this used to override the selections))
			additional_tag_area.append(opt)
			# Due to how Semantic works, a timeout/delay had to be added to get this to work, if there's errors try changing the value from 1 to a larger number
			setTimeout (->
				additional_tag_area.dropdown 'refresh' # Refresh the dropdown with the new data
				additional_tag_area.dropdown 'set selected', new_tag_value # Select the new option based upon it's value
			), 0.1
			# Remove the option from the addition_dropdown select list
			additional_dropdown.find('option[value="' + value + '"]').remove()
			# Reset the additional tag dropdowns to their initial selected values and placeholder text
			additional_input.dropdown 'clear'
			additional_dropdown.dropdown 'clear'
			additional_dropdown.dropdown 'set text', 'Additional Feature'
			additional_input.dropdown 'set selected', '1'
		else
			# Otherwise send an alert
			alert 'Please select an additional feature and quantity and try again'

	# Refresh the addition tag dropdown selector field incase we're editing an exisitng listing which has tags
	# (the server will set them selected, but Semantic, needs to add the tags)
	additional_tag_area.find('option').each (i) ->
		# If it's not the placeholder option and options existing on page load then they're from the server and need to be set selected
		if $(this).val() != ''
			additional_tag_area.dropdown 'set selected', $(this).val()
		# Refresh the dropdown to see the changes from the removal
		setTimeout (->
			# Refresh to get the latest list of options
			additional_dropdown.dropdown 'refresh' 
		), 0.1
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

	# --------- FORM OBJECT ITSELF
	# 
	# Form validation rules
	validation_rules = 
		type: # Can't be empty
			identifier: 'listing[listing_type]'
			rules: [{
				type: 'empty'
				prompt: 'Please select a listing type'
			}]
		address: # Can't be empty, or over 256 characters
			identifier: 'listing[listing_address]'
			rules: [
				{
					type: 'empty'
					prompt: 'Please enter a street address'
				},
				{
					type: 'maxLength[256]'
					prompt: 'Please enter less than 256 characters'
				}
			]
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
		bedrooms: # Can't be empty, or greater than 50
			identifier: 'listing[listing_bedrooms]'
			rules: [
				{
					type: 'empty'
					prompt: 'Please enter the number of bedrooms'
				},
				{
					type: 'integer[1..50]'
					prompt: 'Please enter a number between 1 and 50'
				}
			]
		bathrooms: # Can't be empty, or greater than 50
			identifier: 'listing[listing_bathrooms]'
			rules: [
				{
					type: 'empty'
					prompt: 'Please enter the number of bathrooms'
				},
				{
					type: 'integer[1..50]'
					prompt: 'Please enter a number between 1 and 50'
				}
			]
		parking: # Can't be empty, or greater than 50
			identifier: 'listing[listing_parking]'
			rules: [
				{
					type: 'empty'
					prompt: 'Please enter the number of parking spots'
				},
				{
					type: 'integer[1..50]'
					prompt: 'Please enter a number between 1 and 50'
				}
			]
		lot_size: # Can't be empty, or greater than 100000
			identifier: 'listing[listing_land_size]'
			rules: [
				{
					type: 'empty'
					prompt: 'Please enter the lot size'
				},
				{
					type: 'integer[1..100000]'
					prompt: 'Please enter a number between 1 and 100,000'
				}
			]
		price_type: # Can't be empty
			identifier: 'listing[listing_price_type]'
			rules: [{
				type: 'empty'
				prompt: 'Please select a price type'
			}]
		price_min: # Can't be empty, or not a number, or not a number greater than 10 characters
			identifier: 'listing[listing_price_min]'
			rules: [
				{
					type: 'empty'
					prompt: 'Please enter a price'
				},
				{
					type: 'number'
					prompt: 'Please enter a number for the minimum price'
				},
				{
					type: 'maxLength[10]'
					prompt: 'Please enter a number with 10 or less digits'
				}
			]
		price_max: # Can't be empty, or not a number, or not a number greater than 10 characters
			identifier: 'listing[listing_price_max]'
			rules: [
				{
					type: 'empty'
					prompt: 'Please enter a maximum price'
				},
				{
					type: 'number'
					prompt: 'Please enter a number for the maximum price'
				},
				{
					type: 'maxLength[10]'
					prompt: 'Please enter a number with 10 or less digits'
				}
			]
		description: # Can't be empty, or more than 2000 characters (actual database limit is between 21,844 and 65,535 due to the size limits in MySQL 
			#varying for a text area column, depending on how many bytes per character [for UTF-8 that can be 1 - 3 bytes per character, hence 21,844 - 65,535])
			identifier: 'listing[listing_description]'
			rules: [
				{
					type: 'empty'
					prompt: 'Please enter a description'
				},
				{
					type: 'maxLength[2000]'
					prompt: 'Please enter less than 2,000 characters'
				}
			]
		title: # Can't be empty, or more than 64 characters
			identifier: 'listing[listing_title]'
			rules: [
				{
					type: 'empty'
					prompt: 'Please enter a title'
				},
				{
					type: 'maxLength[64]'
					prompt: 'Please enter less than 64 characters'
				}
			]
		subtitle: # Can't be empty, or more than 128 characters
			identifier: 'listing[listing_subtitle]'
			rules: [
				{
					type: 'empty'
					prompt: 'Please enter a subtitle'
				},
				{
					type: 'maxLength[128]'
					prompt: 'Please enter less than 128 characters'
				}
			]
	
	# ---- Set up form using validation rules above, plus additional settings
	# 
	# Bind the rules to the form and set form options (the only way I found to get the errors was to set inline to true)
	$('#add-edit-listing-form').form
		inline: true
		fields: validation_rules
		# Turn keyboard shortcuts off for the semantic form
		keyboardShortcuts: false
		# Called if validate form call detects an error
		onFailure: (formErrors, fields) ->
			# Get the field with the error (so we can find the tab it's in)
			input_with_error = $('.field.error')
			# Get the tab it's in
			tab = input_with_error.closest('.ui.tab')
			# If the tab with the error field isn't active then remove the active class from the active tab and add it
			# to the tab with the error so it will become visible
			if !tab.hasClass('active')
				# Using data-tab selector so we remove it from the menu item and the active tab as well
				active_tab = $('.ui.tab.active')
				# Now we have the active tab, lets remove the class from it and the menu item and then add it to the one we want
				# to activate (and it's corresponding menu item)
				$('[data-tab="' + active_tab.data('tab') + '"]').removeClass('active')
				$('[data-tab="' + tab.data('tab') + '"]').addClass('active')
				
			# Return false so it doesn't submit until there's no errors
			return false

	# ---- Enter Keypress to submit form
	# 
	# Submit the form with a keyboard enter key press if the dropdown fields aren't selected
	$(document).keypress (key) ->
		# Enter key (submit handler)	
		if key.which == 13
			# If the key press target (i.e. what was active) didn't have the class dropdown then submit the form
			# Also, disable the enter key to submit when in the listing_description textarea to enable multiple line descriptions
			if !$('key.target').hasClass('dropdown') and $(key.target).prop('id') != 'listing_listing_description'
				# Only submit the form if it's valid
				if $('#add-edit-listing-form').form 'is valid'
					$('#add-edit-listing-form').form 'submit'
				# Otherwise, validate it so the onFailure method is called.
				else
					$('#add-edit-listing-form').form 'validate form'

	# ---- Button click to submit form
	# 
	# Submit the form using the action defined by the form itself. (As the button is outside of the form I need to call submit on it via javascript)
	$('#add-edit-submit-button').on 'click', ->
		# If we've changed the selector for the price type and we've updated the fixed price value then we need to store it in the max field as well
		if $('#add-edit-price-dropdown').val() == 'F'
			# We need to change it here when saving as you might have changed it after selecting fixed price (so min and max won't line up anymore)
			$('#price-field-max-input').val($('#price-field-min-input').val())
		# Submit the form only if it's valid
		if $('#add-edit-listing-form').form 'is valid'
			$('#add-edit-listing-form').form 'submit'
		# Otherwise, validate it so the onFailure method is called.
		else
			$('#add-edit-listing-form').form 'validate form'
		return

	# ---------- Upload images code
	# Custom File Upload button and on file selection change event handled in this below.
	# 
	# Because we're styling the label to perform the actions of the button we need this code to update the label with the chosen file(s)
	# 
	# Preview the added image and add a new add image button when the input field value changes (i.e. we've chosen some files)
	# Also update the replacement file picker label (as we're hiding the #picture-input element) to display the file name(s)
	$ ->
		$('#picture-input').on 'change', (event) ->
			# Remove any previous preview image cards from the cards list
			$(".ui.cards [id^='blank-picture-card']").remove()
			
			# Get reference to the input field that's hidden and the label we're using to display the selection
			$input = $(this)
			$label = $input.next('label')
			labelVal = $label.html()
			
			# Get the files from the input field
			files = event.target.files
			
			# Update the label based upon the selected files
			if files and files.length > 1
				# More than one file so lets grab the caption we've hidden in the $input field and update it
				fileName = (@getAttribute('data-multiple-caption') or '').replace('{count}', @files.length)
			else if event.target.value
				# Only one file. Grab it's file name
				fileName = event.target.value.split('\\').pop()
			# If we have the filename lets update the label
			if fileName
				$label.find('span').html fileName
			else
				$label.html labelVal

			# Iterate over each file and create a preview for it
			$.each files, (key, value) ->
				# Counter so we can generate a unique image card id to target
				count = key + 1
				# Generate the unique image card, set its id = count and set it to display: block (as the blank one is hidden)
				temp = $('#blank-picture-card').clone()
				temp.attr('id', 'blank-picture-card-' + count)
				temp.css('display', 'block')
				# Append the card to the ui cards containing element
				temp.appendTo('#listing-photos-list')
				# Get the image
				image = value
				# Create a new file reader that will load the file into the div we specify
				reader = new FileReader
				reader.onload = (file) ->
					# Create an image tag
					img = new Image
					img.src = file.target.result
					# Put the image in the div we've specified
					$('#blank-picture-card-' + count + ' .image-target').html img
					# Size it to fit in the preview if it's a smaller height than the containing card (2 parent levels up)
					item = $('#blank-picture-card-' + count + ' .image-target img')
					img_height = item.height()
					div_height = item.parent().parent().height()
					# If the img_height is less than the container height then size it and crop to fit
					if img_height < div_height
						# Resize it to be as big as the container
						item.css
							'width': 'auto',
							'height': div_height
						# Get the new width and containers actually width
						img_width = item.width()
						div_width = item.parent().parent().width()
						# Set a left margin so the image is centered in the container (overflow will be hidden)
						new_margin = (div_width - img_width) / 2 + 'px'
						item.css 'margin-left', new_margin
					return
				# Render the preview image using the created reader
				reader.readAsDataURL image
				return

			# If there are more than 10 images then warn the user
			listing_preview_cards = $('#listing-photos-list')
			if files and files.length > 10
				# If you're uploading more than 10 then warn the user
				$('#add-edit-images-warning').css 'display', 'block'
				$('#add-edit-submit-button').attr 'disabled', 'disabled'
			else
				if listing_preview_cards.find('.card').length > 10
					# Else, if you now have more than 10 images previewed, warn the user
					$('#add-edit-images-warning').css 'display', 'block'
					$('#add-edit-submit-button').attr 'disabled', 'disabled'
				else
					# otherwise, both of these failed so we can enable the button and hide the warning
					$('#add-edit-images-warning').css 'display', 'none'
					$('#add-edit-submit-button').removeAttr 'disabled'


			return
		return

	# Hide the image the delete button was clicked on and mark it for deletion by the server when the form is updated
	$('.add-edit.property-card.delete-button').click ->
		# Get the id of the image we're deleting
		image_to_delete = $(this).data('id')
		# Get the parent element which we need to hide the card
		card_to_hide = $(this).parent()
		# Mark the associated checkbox as checked so we tell rails to delete the photo
		$('#destroy-image-' + image_to_delete).prop 'checked', true
		# Hide the card 
		# We hide rather than remove so that the hidden checkbox remains otherwise we won't actually delete it
		card_to_hide.css 'display', 'none'
		# Check if to warn the user of the amount of images left still
		listing_preview_cards = $('#listing-photos-list')
		# As the cards aren't deleted until the form is submitted, we need to count the visible images
		if listing_preview_cards.find('.card[style*="display: block"]').length > 10
			# If you now have more than 10 images previewed, warn the user
			$('#add-edit-images-warning').css 'display', 'block'
			$('#add-edit-submit-button').attr 'disabled', 'disabled'
		else
			# Otherwise, so we can enable the button and hide the warning
			$('#add-edit-images-warning').css 'display', 'none'
			$('#add-edit-submit-button').removeAttr 'disabled'

		# Return False as the button actually submits the form otherwise (which we don't want to happen)
		return false

	# Show an indicator that the file will be uploaded and disable the click action on it so it doesn't submit the form
	# This is assigned this way so any preview image cards we add dynamically (see above function) have a button click assigned
	# If we don't do this, then clicking the delete button for the dynamic cards submits the form
	$(document).on 'click', '.add-edit.property-card.upload-button', ->
		alert 'This photo will be uploaded when you submit the form'
		return false

	# Handle the selection of the main image so we can update the main image
	$("input[id^='select-cover-image']").change ->
		# Get the checkbox and the photo id we need to store as the main image
		checkbox = $(this)
		checkbox_id = $(this).attr('id')
		photo_id = $(this).parent().data('id')
		# Loop through the over checkboxes and turn them off if this one is checked
		if checkbox.prop 'checked', true
			checkbox.siblings('span').text('Main Image')
			$("input[id^='select-cover-image']").each ->
				if $(this).attr('id') != checkbox_id
					if $(this).prop 'checked', true
						$(this).prop 'checked', false
						$(this).siblings('span').text('Make Main Image')
		return

	# ---------- Extra's tab code
	# 
	# Handle clicks in the extra's tag checkboxes to untick the listing-premium-none option if another one is clicked
	$('#listing-extra-checkboxes input[type="checkbox"]').change ->
		if $(this).prop('name') == 'listing-premium-none'
			# The listing-premium-none checkbox was hit, lets uncheck any other checkboxes if this one is now true
			if $(this).prop('checked') == true
				# As listing-preium-none is now checked, lets uncheck any other checkboxes that are also checked
				# Users can't be allowed to save listings with premium features AND also saying they want no premium features
				$('#listing-extra-checkboxes input[type="checkbox"]').each ->
					if $(this).prop('name') != 'listing-premium-none'
						$(this).first().prop 'checked', false
		else
			# Another checkbox was hit, lets set the listing-premium-none checkbox to unchecked if it is already checked
			is_lpn_checked = $('#listing-extra-checkboxes input[name="listing-premium-none"]').prop 'checked'
			if $(this).prop('checked') == true and is_lpn_checked == true
				# Set the listing-premium-none checked property to false
				$('#listing-extra-checkboxes input[name="listing-premium-none"]').prop 'checked', false

	return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
