#   Created: Daniel Swain
#   Date: 18/04/2016
# 
#   The following coffeescript is for the entire site
# 
#   Todo:

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
$(document).on 'page:load', ready
