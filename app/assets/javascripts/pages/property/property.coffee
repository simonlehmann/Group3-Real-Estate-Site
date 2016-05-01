# Created: Jayden Spencer
# Date: 30/04/2016
# 
# The following coffeescript is for the property page
# 
# TODO:
#
ready = ->


# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready