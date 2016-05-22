#   Created: Daniel Swain
#   Date: 18/04/2016
# 
#   The following coffeescript is for the entire site
# 
#   Todo:

# Function used for changing the header image based on state
@changeImage = (state) ->
	if state == 'Western Australia'
		$('.search-section').addClass 'wa-img'
		$('.search-section').removeClass 'vic-img qld-img act-img nsw-img sa-img nt-img tas-img ot-img'
	else if state == 'Victoria'
		$('.search-section').addClass 'vic-img'
		$('.search-section').removeClass 'wa-img qld-img act-img nsw-img sa-img nt-img tas-img ot-img'
	else if state == 'Queensland'
		$('.search-section').addClass 'qld-img'
		$('.search-section').removeClass 'vic-img wa-img act-img nsw-img sa-img nt-img tas-img ot-img'
	else if state == 'Australian Capital Territory'
		$('.search-section').addClass 'act-img'
		$('.search-section').removeClass 'vic-img qld-img wa-img nsw-img sa-img nt-img tas-img ot-img'
	else if state == 'New South Wales'
	 	$('.search-section').addClass 'nsw-img'
	 	$('.search-section').removeClass 'vic-img qld-img act-img wa-img sa-img nt-img tas-img ot-img'
	else if state == 'South Australia'
		$('.search-section').addClass 'sa-img'
		$('.search-section').removeClass 'vic-img qld-img act-img nsw-img wa-img nt-img tas-img ot-img'
	else if state == 'Northern Territory'
		$('.search-section').addClass 'nt-img'
		$('.search-section').removeClass 'vic-img qld-img act-img nsw-img sa-img wa-img tas-img ot-img'
	else if state == 'Tasmania'
		$('.search-section').addClass 'tas-img'
		$('.search-section').removeClass 'vic-img qld-img act-img nsw-img sa-img nt-img wa-img ot-img'
	else if state == 'Other Territories'
		$('.search-section').addClass 'ot-img'
		$('.search-section').removeClass 'vic-img qld-img act-img nsw-img sa-img nt-img tas-img wa-img'
	else
		$('.search-section').addClass 'wa-img'
		$('.search-section').removeClass 'vic-img qld-img act-img nsw-img sa-img nt-img tas-img ot-img'
	return
# Function used to remove current applied state classes except the selected state
@remove_classes = (state) ->
	classes = [
		['wa-img', 'Western Australia'],
		['vic-img', 'Victoria'],
		['qld-img', 'Queensland'],
		['sa-img', 'South Australia'],
		['nt-img', 'Northern Territory'],
		['tas-img', 'Tasmania'],
		['act-img', 'Australian Capital Territory'],
		['ot-img', 'Other Territories'],
		['nsw-img', 'New South Wales']
		]
	i = 0
	while i < classes.length
		j = 0
		while j < classes[i].length
			if state != classes[i][1]
				$('.search-section').removeClass(classes[i][0])
			j++
		i++
	return

# Utility function to pluralise a string
@get_plural = (string) ->
	# Check for words that are not required to be pluralised, else pluralise them
	switch string
		# For the following tag type labels, just return the string as we don't want it pluralised
		# NB, need to lead with a ',' to prevent the new line causing an unexpected indentation in coffeescript
		when 'Airconditioning', 'Ducted Cooling', 'Ducted Heating', 'Evaporative AC', 'Gas Heating', 'Reverse Cycle', 'Split System'
		,	'Grey Water', 'Solar', 'Solar Hot Water', 'Pay TV', 'Satelite TV', 'Ocean Views', 'NBN', 'Established Home', 'New Home'
		,	'Pet Friendly', 'Wheelchair Access'
			return string
		else
			# Handle words we want pluralised, this supports words ending in 'y' as well as normal words. Not locale specific
			# Check the last character for a 'y' or an 's'
			last_char = string.slice(-1)
			# Return the pluralised string based on the last_char
			return if last_char == 'y' then string.slice(0,-1) + 'ies' else string + 's'


# Function containing all javascript needed on page load
ready = ->

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

	# Dismiss the nearest Semantic message with a close icon
	$('.message .close').on 'click', ->
		$(this).closest('.message').transition 'fade'
		return

	# Show a tooltip popup on all password input/change fields both in the modal and on the devise pages (set the content and width here, either wide or very wide)
	$('.password-popup').popup
		on: 'focus'
		inline: true
		exclusive: true
		variation: 'very wide'
		content: 'Your password must be at least 8 characters long and include: 1 capital letter, 1 lowercase letter and either 1 symbol or 1 number.'
	
	return
# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
