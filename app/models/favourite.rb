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
#   Relations:
# 		* a favourite listing refers to the user favouriting it and the listing being favourited

class Favourite < ActiveRecord::Base
	self.table_name = "favourites"

end
