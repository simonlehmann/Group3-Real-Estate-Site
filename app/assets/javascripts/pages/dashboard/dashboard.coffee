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
		
	# Show a preview of the to be uploaded image if the user is choosing a new one.
	$('#user-avatar-crop-modal').modal(
		onVisible: ->
			# Show the preview on the dashboard/settings page so it can render the cropped area when this modal is closed
			# Done in onVisible so it only shows when the Modal obscure's it
			$('#avatar-crop-preview-image').css 'display', 'block'
		onApprove: ->
			$('#avatar-crop-preview-image').css 'display', 'block'
			$('#file-upload-preview-image').css 'display', 'none'
		onHide: ->
			# When the modal starts hiding, if the crop button didn't set the file-upload-preview-image to display none then hide the crop
			# preview as the user didn't make a crop
			is_file_upload_shown = $('#file-upload-preview-image').css 'display'
			if is_file_upload_shown != 'none'
				$('#avatar-crop-preview-image').css 'display', 'none'
		onShow: ->
			# On modal show, if we have chosen to load a new file then show a preview in the crop modal
			# so we can crop it after it is saved.
			file_list = $('#avatar-input').prop 'files'
			# This only runs if we're uploading a file
			if file_list.length == 1
				# Get the file from the file list and create a new FileReader to load it
				image = file_list[0]
				reader = new FileReader
				reader.onload = (file) ->
					# Create the image that will be placed in the divs
					src = file.target.result
					img = new Image
					img.src = src
					# Place the image in a hidden div to get the real dimensions (see note below)
					$('#hidden-image').html img
					real_width = $('#hidden-image img').width()
					real_height = $('#hidden-image img').height()
					# Disable the hidden image
					$('#hidden-image').css 'display', 'none'
					# Set the cropbox image and preview image to the one being uploaded
					$('#avatar_cropbox img').attr 'src', src
					$('#avatar_crop_preview_wrapper img').attr 'src', src
					# Store the value of the real image dimensions and the dimensions of the jcrop window which holds the crop selector (see note)
					$('#img-real-width').val(real_width)
					$('#img-real-height').val(real_height)
					$('#img-real-aspect').val(real_width / real_height)
					crop_window_width = parseInt($('.jcrop-holder').css 'width')
					crop_window_height = parseInt($('.jcrop-holder').css 'height')
					$('#img-crop-window-width').val(crop_window_width)
					$('#img-crop-window-height').val(crop_window_height)
					$('#img-crop-window-aspect').val(crop_window_width / crop_window_height)
					# NB These values are required so we can accurately crop the previewed image.
					# The values returned from the jCrop plugin refer to the original image, but this isn't what we see.
					# We see the image squashed into the 400px container. i.e. a 800 wide image will show the cropper on the
					# 400 wide image, but all the values it returns are related to the 800 wide image.
					# 
					# Thankfully we have access to the values of the cropper field over the 400 wide preview image and can there
					# for do some simple math to relate the value of the preview we see (which is the crop we want) and the values required
					# to correctly crop the 800 wide image. Basically it boils down to an equation like this
					# crop_x = (real_image_width/crop_preview_image_width) * preview_crop_window_left_value
					# 
					# and similar formulas for crop_y, crop_w and crop_h.
				
				# Load the image using the file reader above
				reader.readAsDataURL image
		).modal 'attach events', '.open-crop-modal', 'show'

	# Save the crop selection
	$('#user-avatar-crop-modal #user-avatar-crop-modal-save').click ->
		# Get the crop values
		crop_x = parseInt($('#avatar_crop_x').val())
		crop_y = parseInt($('#avatar_crop_y').val())
		crop_w = parseInt($('#avatar_crop_w').val())
		crop_h = parseInt($('#avatar_crop_h').val())
		# Get the values from the preview window (only used if the user is uploading a new image to calculate the correct crop_ vals)
		# These values sit in the .jcrop-holder's first div as css properties left, top, width and height for x, y, w and h respectively
		prev_x = parseInt($('.jcrop-holder div').first().css 'left')
		prev_y = parseInt($('.jcrop-holder div').first().css 'top')
		prev_w = parseInt($('.jcrop-holder div').first().css 'width')
		prev_h = parseInt($('.jcrop-holder div').first().css 'height')
		# Get the values from the real width/height and jcrop-holder width/height if any
		real_w = if isNaN(parseInt($('#img-real-width').val())) then 0 else parseInt($('#img-real-width').val())
		real_h = if isNaN(parseInt($('#img-real-height').val())) then 0 else parseInt($('#img-real-height').val())
		real_a = if isNaN($('#img-real-aspect').val()) then 1 else $('#img-real-aspect').val()
		holder_w = if isNaN(parseInt($('#img-crop-window-width').val())) then 0 else parseInt($('#img-crop-window-width').val())
		holder_h = if isNaN(parseInt($('#img-crop-window-height').val())) then 0 else parseInt($('#img-crop-window-height').val())
		holder_a = if isNaN($('#img-crop-window-aspect').val()) then 0 else $('#img-crop-window-aspect').val()
		# The stock crop box is placed 0 0 and 250 high and wide, so if it hasn't moved, I'm going to ignore it.
		# But it's cool if it's 250x250 still and it's cool if it's still on the top or left side as long as not both
		if (crop_x != 0 or crop_y != 0) and (prev_x != 0 or prev_y != 0)
			if real_w != 0 and real_h != 0 and holder_w != 0 and holder_h != 0 and holder_a != 0 and real_a != 0
				# Saving crop to image being uploaded
				
				# Lets hide the file-upload-avatar-preview window as we wan't to show the crop preview to see the live crop result before an upload
				$('#file-upload-avatar-preview').css 'display', 'none'
				
				# Interpolate from the real_ and holder_ values, along with the prev_ values to calculate the correct crop_ values
				# we need to correctly crop the uploaded image to match the selected area (see not in modal code above)
				# Calculated values, from simple maths/ratio's as the images are the same, just transformed i.e. holder_w / crop_x == real_w / prev_w ...
				calc_x = parseInt((real_w / holder_w) * prev_x)
				calc_y = parseInt((real_h / holder_h) * prev_y)
				calc_w = parseInt((real_w / holder_w) * prev_w)
				calc_h = parseInt((real_h / holder_h) * prev_h)
				#Adjust the values for changes in aspect ratio 
				# * if the source aspect is 1:1 and the crop window isn't the add the difference in the crop window's height and width to the calc_h
				# * if the source aspect isn't 1:1 and the crop window is then add the difference in the source images's height and width to the calc_w
				# This was done as Papercrop expects 1:1 aspect ratio on cropping, so I'm either padding the height if it's been stretched in the x direction
				# or padding the width if the image has been strecthed in the y direction
				if real_a > holder_a # i.e. real_a = 1 and holder_a < 1 (width to height)
					calc_h = calc_h + Math.abs(holder_w - holder_h)
					# Shift the y crop value up half the holder_w - holder_h distance if there's room. To correct for the aspect change
					calc_y = if (calc_y - (Math.abs(holder_w - holder_h) / 2)) > 0 then parseInt((calc_y - (Math.abs(holder_w - holder_h) / 2))) else calc_y
				else if real_a < holder_a # i.e. real_a < 1 and holder_a = 1 (width to height)
					calc_w = calc_w + Math.abs(real_w - real_h)
					# Shift the x crop value left half the image_w - image_h value if there's room. To correct for the aspect change
					calc_x = if (calc_x - (Math.abs(real_w - real_h) / 2)) > 0 then parseInt((calc_x - (Math.abs(real_w - real_h) / 2))) else calc_x
				# Set them to enabled so they are sent when the form is submitted (do this first so we can store the values)
				$('#avatar-crop-values #avatar_crop_x').prop 'disabled', false
				$('#avatar-crop-values #avatar_crop_y').prop 'disabled', false
				$('#avatar-crop-values #avatar_crop_w').prop 'disabled', false
				$('#avatar-crop-values #avatar_crop_h').prop 'disabled', false
				# Clear the calculated temp aspect values from their input fields (as they might not be whole numbers)
				$('#img-real-aspect').val(0)
				$('#img-crop-window-aspect').val(0)
				# Store the calculated values in the form_fields so they are submitted to the server
				$('#avatar-crop-values #avatar_crop_x').val(calc_x)
				$('#avatar-crop-values #avatar_crop_y').val(calc_y)
				$('#avatar-crop-values #avatar_crop_w').val(calc_w)
				$('#avatar-crop-values #avatar_crop_h').val(calc_h)
			else
				# Saving crop to existing image
				
				# Lets hide the file-upload-avatar-preview window as we wan't to show the crop preview to see the live crop result before an upload
				$('#file-upload-avatar-preview').css 'display', 'none'
				
				# Set the Form fields that share ids to be enabled as we want to save them
				# The values in them from the crop selector are correct as the jcrop-holder has the dimensions 
				# that match the image as it's cropping an existing image and is loaded correctly. That means 
				# we don't need to do anything other than set the disabled property to false so we can submit them
				$('#avatar-crop-values #avatar_crop_x').prop 'disabled', false
				$('#avatar-crop-values #avatar_crop_y').prop 'disabled', false
				$('#avatar-crop-values #avatar_crop_w').prop 'disabled', false
				$('#avatar-crop-values #avatar_crop_h').prop 'disabled', false
				# Clear the calculated temp aspect values from their input fields (as they might not be whole numbers)
				$('#img-real-aspect').val(0)
				$('#img-crop-window-aspect').val(0)
		else
			# Set the form fields to be disabled so they aren't submitted
			$('#avatar-crop-values #avatar_crop_x').prop 'disabled', true
			$('#avatar-crop-values #avatar_crop_y').prop 'disabled', true
			$('#avatar-crop-values #avatar_crop_w').prop 'disabled', true
			$('#avatar-crop-values #avatar_crop_h').prop 'disabled', true

			# Clear the calculated temp aspect values from their input fields (as they might not be whole numbers)
			$('#img-real-aspect').val(0)
			$('#img-crop-window-aspect').val(0)

	# Crop selection form cancel button clicker
	$('#user-avatar-crop-modal #user-avatar-crop-modal-cancel').click ->
		# Set the form fields that hold the crop values to be disabled so they aren't sent when we save the form
		$('#avatar-crop-values #avatar_crop_x').prop 'disabled', true
		$('#avatar-crop-values #avatar_crop_y').prop 'disabled', true
		$('#avatar-crop-values #avatar_crop_w').prop 'disabled', true
		$('#avatar-crop-values #avatar_crop_h').prop 'disabled', true
		# Clear the calculated temp aspect values from their input fields (as they might not be whole numbers)
		$('#img-real-aspect').val(0)
		$('#img-crop-window-aspect').val(0)
		# Hide the preview on the dashboard/settings page so it can render the cropped area when this modal is closed
		$('#file-upload-preview-image').css 'display', 'block'
		$('#avatar-crop-preview-image').css 'display', 'none'


	checkField = undefined
	#checking the length of the value of message and assigning to a variable(checkField) on load
	checkField = $('input#message').val().length

	enableDisableButton = ->
		if checkField > 0
			$('#sendButton').removeAttr 'disabled'
		else
			$('#sendButton').attr 'disabled', 'disabled'
		return

	#calling enableDisableButton() function on load
	enableDisableButton()
	$('input#message').keyup ->
		#checking the length of the value of message and assigning to the variable(checkField) on keyup
		checkField = $('input#message').val().length
		#calling enableDisableButton() function on keyup
		enableDisableButton()
		return
	return

$(document).ready ready
