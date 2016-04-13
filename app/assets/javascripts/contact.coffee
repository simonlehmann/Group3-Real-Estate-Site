# Created by Erdal Erkilic
# 13/4/16
# This is all javascript realated to the contact page

# Moved into one ready function to be called across page load and document.ready as discussed on Slack
ready = ->

# Created by Erdal Erkilic
# 13/4/16
# This is all javascript realated to the contact page

# Moved into one ready function to be called across page load and document.ready as discussed on Slack
ready = ->
	$('.ui.modal').modal onApprove: ->
		#Submits the semantic ui form
        #And pass the handling responsibilities to the form handlers,
        # e.g. on form validation success
		$('.ui.form').submit()
		false
		#Return false as to not close modal dialog
	formValidationRules = title:
		identifier: 'name'
		rules: [ {
			type: 'empty'
			prompt: 'Please enter a title'
		} ]
	formSettings = onSuccess: ->
		#Hides modal on validation success
		alert 'Valid Submission, modal will close.'
		$('.modal').modal 'hide'
		return
	$('.ui.form').form formValidationRules, formSettings

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready