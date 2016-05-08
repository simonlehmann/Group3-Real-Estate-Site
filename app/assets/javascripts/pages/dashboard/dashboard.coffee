ready = ->
	$('.ui.sticky.dashboard-submenu').sticky
		offset: 71
		context: '#activity-feed'

	# Initialise the tab menu
	$('.dashboard-submenu .dashboard-tabular.menu .item').tab(
		# On tab load, change the window history so the path mirrors the active tab (without redirecting the page)
		onLoad: ->
			window.history.replaceState('activeTab', '', '/dashboard/' + $('#activity-feed .tab.active').attr('data-tab'))
		)

	# Show a preview of the profile picture you're about to save
	$ ->
		$('#avatar-input').on 'change', (event) ->
			# Get reference to the input field that's hidden and the label we're using to display the selection
			$input = $(this)
			$label = $input.next('label')
			labelVal = $label.html()
			# Get the files from the input field (we expect it to be length one as its a single file upload field)
			files = event.target.files 
			# Update the custom label based upon the selected file
			if event.target.value and files.length == 1
				# Only one file. Grab it's file name
				fileName = event.target.value.split('\\').pop()
			# If we have the filename lets update the label
			if fileName
				$label.find('span').html fileName
			else
				$label.html labelVal
			# Update the target dive with the chosen image
			image = files[0]
			# Create a new file reader that will load the file into the div we specify
			reader = new FileReader
			reader.onload = (file) ->
				# Create an image tag
				img = new Image
				img.src = file.target.result
				# Put the image in the div we've specified
				$('.avatar-target').html img
			# Render the preview image using the created reader
			reader.readAsDataURL image
			return
		return

$(document).ready ready
$(document).on 'page:load', ready
