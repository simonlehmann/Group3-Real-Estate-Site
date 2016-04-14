#   Created: Daniel Swain
#   Date: 13/04/2016
#   
#   The Model class for the property listings, represents a listing

class Listing < ActiveRecord::Base
	# Set the maximum listings to be shown initially (i.e. listings per page)
	paginates_per 5
end
