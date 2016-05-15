# Created: Michael White
# Date: 05/04/2016
# 
# The following coffeescript is for the index/buy page.
# 
# TODO:
#
ready = ->
	# Dropdown variables for convenience
	add_criteria_dropdown = $('.criteria-selection .dropdown.button')
	criteria_tag_field = $('#tag_dropdown')

	# Settings for criteria dropdown
	add_criteria_dropdown.dropdown
		# On option select, don't do anything, only select the option
		action: 'select'
		# On change (select), remove the selection from the criteria dropdown and add them as tags to the tag dropdown
		onChange: (value, text, $choice) ->
			# Get the category of the option
			choiceVal = $choice.context.attributes.value.textContent
			# If statement to determine which category the label is and create it appropriately
			if choiceVal == 'Price'
				$('<a class="ui tag orange label" data-catid="' + choiceVal + "_" + text + '" value="'+ choiceVal + '">' + text + '</option><i class="delete icon"></i>').appendTo(criteria_tag_field)
			else if choiceVal == 'House Type' || choiceVal == 'Bedrooms' || choiceVal == 'Bathrooms' || choiceVal == 'Parking'
				$('<a class="ui blue label" data-catid="' + choiceVal + "_" + text + '" value="'+ choiceVal + '">' + text + '</option><i class="delete icon"></i>').appendTo(criteria_tag_field)
			else if choiceVal == 'Appliances' || choiceVal == 'Eco Friendly' || choiceVal == 'Heating Cooling' || choiceVal == 'Leisure' || choiceVal == 'Outdoor Features'
				$('<a class="ui purple label" data-catid="' + choiceVal + "_" + text + '" value="'+ choiceVal + '">' + text + '</option><i class="delete icon"></i>').appendTo(criteria_tag_field)

			setTimeout (->
				# Refresh the dropdown with the newly added criteria
				criteria_tag_field.dropdown 'refresh' 
			), 0.1
			# If it's the first tag in the dropdown, it won't be visible, so make it visible
			if !criteria_tag_field.dropdown 'is visible'
				criteria_tag_field.show()
			# Hide this option from the criteria dropdown
			$choice.hide()
	# When the delete icon on the label is clicked, do this
	$(document).on 'click', '#tag_dropdown .delete.icon', (e) ->
    	e.preventDefault()
    	# Get text of the option selected
    	toSearch = $(this).parent().text()
    	# Search for the option in the criteria dropdown
    	$('.criteria-selection .item').each (index) ->
    		if $(this).text() == toSearch
    			# Show the option in criteria dropdown
    			$(this).show()
    	# Remove the label
    	$(this).parent().remove()
    	# Check if there are any labels left in the dropdown
    	if criteria_tag_field.find('a').length < 1
    		# Hide the label dropdown
    		criteria_tag_field.hide()
    # Initially, hide the criteria dropdown
	criteria_tag_field.hide()

$(document).ready ready