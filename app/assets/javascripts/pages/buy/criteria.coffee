# Created: Michael White
# Date: 05/04/2016
# 
# The following coffeescript is for the index/buy page.
# 
# TODO:
#
class Item
	constructor: (@text, @category) ->

items = []

ready = ->
	$('.criteria-selection .dropdown.button').dropdown
		action: 'select'
		onChange: (value, text, $choice) ->
			$choice.remove()
			
		items[0] = new Item('item1', 'cat1')
		items[1] = new Item('item2', 'cat2')
		console.log items[0].text, items[1].text

$(document).ready ready