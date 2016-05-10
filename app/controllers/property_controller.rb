class PropertyController < ApplicationController
  def index
  	#will return address-suburb-state-postcode-id
  	request_path = request.original_fullpath
  	#split path name and get id
  	property_id = request_path.split("-").last.to_i
  	puts property_id
  	#get property by id from DB
  	@listing = Listing.find_by_listing_id(property_id)
  end
end
