class PropertyController < ApplicationController
	
	include ApplicationHelper
	include SellHelper

	def index
		#will return address-suburb-state-postcode-id
		request_path = request.original_fullpath
		#split path name and get id
		property_id = request_path.split("-").last.to_i
		#get property by id from DB
		@listing = Listing.find_by_listing_id(property_id)
		@prev_loc = save_my_previous_url()
		@searching = false # Variable to stop infinite scroll working on the property page
	end
end
