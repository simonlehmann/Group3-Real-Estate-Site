# Created: Michael White
# Date: 05/04/2016
# 
# The following coffeescript is for the index/buy page.
# 
# TODO:
#
ready = ->
	add_criteria_dropdown = $('.criteria-selection .dropdown.button')
	criteria_tag_field = $('#tag_dropdown')

	add_criteria_dropdown.dropdown
		action: 'select'
		onChange: (value, text, $choice) ->
			choiceVal = $choice.context.attributes.value.textContent
			$('<a class="ui label" data-catid="' + choiceVal + "_" + text + '" value="'+ choiceVal + '">' + text + '</option><i class="delete icon"></i>').appendTo(criteria_tag_field)
			setTimeout (->
				# Refresh the dropdown with the newly added criteria
				criteria_tag_field.dropdown 'refresh' 
			), 0.1
			if !criteria_tag_field.dropdown 'is visible'
				criteria_tag_field.show()
			$choice.hide()

	$(document).on 'click', '#tag_dropdown .delete.icon', (e) ->
    	e.preventDefault()
    	toSearch = $(this).parent().text()
    	$('.criteria-selection .item').each (index) ->
    		console.log $(this).text()
    		if $(this).text() == toSearch
    			$(this).show()
    	$(this).parent().remove()
    	if criteria_tag_field.find('a').length < 1
    		criteria_tag_field.hide()

	criteria_tag_field.hide()

$(document).ready ready