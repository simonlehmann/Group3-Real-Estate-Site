# Created: Michael White
# Date: 05/04/2016
# 
# The following coffeescript is for the index/buy page.
# 
# TODO:
#
ready = ->
	# Dropdown variables for convenience
	loc = window.location.pathname
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
			# Switch statement to determine which category the label is and create it appropriately
			# Changed from value='choiceVal' to data-cat='Price||Property||Features' to simplify feature search function
			if loc.includes('search')
				switch choiceVal
					when 'Price'
						if $('#price div').length < 1
							$('#price').append('<h5>Price:</h5>')
						$('<div class="ui price-feature-tag tag label" data-price="' + choiceVal + '_' + text + '" data-cat="Price">' + text + '<i class="delete icon"></i></div>').appendTo('#price')
					when 'House Type', 'Bedrooms', 'Bathrooms', 'Parking'
						if $('#property div').length < 1
							$('#property').append('<h5>Property:</h5>')
						$('<div class="ui property-feature-tag label suburb-label" data-category="' + choiceVal + '_' + text + '" data-cat="Property" data-qty="' + searchQty(text) + '">' + text + '<i class="delete icon"></i></div>').appendTo('#property')
					when 'Appliances', 'Eco Friendly', 'Heating Cooling', 'Indoor Features', 'Leisure', 'Outdoor Features'
						if $('#features div').length < 1
							$('#features').append('<h5>Features:</h5>')
						$('<div class="ui label sell-feature-tag" data-feature="' + choiceVal + '_' + text + '" data-cat="Features">' + text + '<i class="delete icon"></i></div>').appendTo('#features')
				doSearch()
			else
				switch choiceVal
					when 'Price'
						$('<div class="ui price-feature-tag tag label" data-catid="' + choiceVal + '_' + text + '" data-cat="Price">' + text + '<i class="delete icon"></i></div>').appendTo(criteria_tag_field)
					when 'House Type', 'Bedrooms', 'Bathrooms', 'Parking'
						$('<div class="ui property-feature-tag label suburb-label" data-catid="' + choiceVal + '_' + text + '" data-cat="Property">' + text + '<i class="delete icon"></i></div>').appendTo(criteria_tag_field)
					when 'Appliances', 'Eco Friendly', 'Heating Cooling', 'Indoor Features', 'Leisure', 'Outdoor Features'
						$('<div class="ui label sell-feature-tag" data-catid="' + choiceVal + '_' + text + '" data-cat="Features">' + text + '<i class="delete icon"></i></div>').appendTo(criteria_tag_field)

			setTimeout (->
				# Refresh the dropdown with the newly added criteria
				criteria_tag_field.dropdown 'refresh' 
			), 0.1
			# If it's the first tag in the dropdown, it won't be visible, so make it visible
			if !criteria_tag_field.dropdown 'is visible'
				if loc.includes('buy')
					criteria_tag_field.show()
			# Hide this option from the criteria dropdown
			$choice.hide()
		#get qty of dropdown selection into search config data tag
		searchQty = (text) ->
			return text.split(' ')[0]

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
				# Remove the active state from the item when it is re-added to criteria dropdown
				$(this).removeClass('selected')
				$(this).removeClass('active')
		# Remove the label
		$(this).parent().remove()
		# Check if there are any labels left in the dropdown 
		# Need to select div.label to hide when all labels are gone, otherwise it won't hide as the criteria_tag_field contains a dropdown div
		if criteria_tag_field.find('div.label').length < 1
			# Hide the label dropdown
			criteria_tag_field.hide()
	# Initially, hide the criteria dropdown
	criteria_tag_field.hide()

	#remove search criteria thats already been selected
	scourDropdown = ->
		#if on search page
		if loc.includes('search')
			#loop through property selections and remove if selected
			#property types
			$('#property div').each (index) ->
				propertyTag = $.trim($(this).text())
				#bathrooms
				$('.criteria-selection .bathrooms .item').each ->
					if propertyTag == $(this).text()
						return $(this).remove()
				#bedrooms
				$('.criteria-selection .bedrooms .item').each ->
					if propertyTag == $(this).text()
						return $(this).remove()
				#parking
				$('.criteria-selection .parking .item').each ->
					if propertyTag == $(this).text()
						return $(this).remove()
				#house
				$('.criteria-selection .housetype .item').each ->
					if propertyTag == $(this).text()
						return $(this).remove()
			#price tags loop through a delete selected
			$('#price div').each (index) ->
				propertyTag = $.trim($(this).text())
				$('.criteria-selection .price .item').each ->
					if propertyTag == $(this).text()
						return $(this).remove()
			#feature tags, loop through a delete selected
			$('#features div').each (index) ->
				propertyTag = $.trim($(this).text())
				#appliances
				$('.criteria-selection .appliances .item').each ->
					if propertyTag == $(this).text()
						return $(this).remove()
				#eco-friendly
				$('.criteria-selection .ecof .item').each ->
					if propertyTag == $(this).text()
						return $(this).remove()
				#heating and cooling
				$('.criteria-selection .heatingcooling .item').each ->
					if propertyTag == $(this).text()
						return $(this).remove()
				#indoor features
				$('.criteria-selection .indoorfeatures .item').each ->
					if propertyTag == $(this).text()
						return $(this).remove()
				#leisure
				$('.criteria-selection .leisure .item').each ->
					if propertyTag == $(this).text()
						return $(this).remove()
				#outdoor features
				$('.criteria-selection .outdoorfeatures .item').each ->
					if propertyTag == $(this).text()
						return $(this).remove()

	scourDropdown()

$(document).ready ready