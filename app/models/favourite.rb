#   Created: Daniel Swain
#   Date: 28/04/2016
#
#   The Model class for the favourites, represents a single favourited listing object
#
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	favourite_id: int (9)
#   	favourite_user_id: int(9)
#   	favourite_listing_id: int(9)
#   	favourite_created_at: timestamp
#
#   Relations: (how to use): If you have a favourite object (i.e. favourite = Favourite.find(1)) then the following methods will return the associated object
#   	favourite.favourite_user - will return the user object associated with the favourite object
#   	favourite.favourite_listing - will return the listing object associated with the favourite object
#   	
#   NOTE:
#   	TALK TO DANIEL AND/OR SIMON BEFORE MODIFYING THESE RELATIONS

class Favourite < ActiveRecord::Base
	self.table_name = "favourites"

	# Relations
	
	# A favourite object can only be associated with one user object (can't refer to the foreign_key here as it won't work if it's set to the stock "id" rails handles it fine without)
	belongs_to :favourite_user, class_name: "User", inverse_of: :user_favourites
	
	# A favourite object can only be associated with one listing object (it is stored in this table)
	belongs_to :favourite_listing, class_name: "Listing", inverse_of: :favourites, foreign_key: "listing_id"
	
end
