# Created: Michael White
# Date: 05/04/2016
# 
# The following coffeescript is for the index/buy page.
# 
# TODO:
#
ready = ->
	$('.criteria-selection .dropdown.button').dropdown
		action: 'select'
		onChange: (value, text, $choice) ->
			$choice.remove()

$(document).ready ready