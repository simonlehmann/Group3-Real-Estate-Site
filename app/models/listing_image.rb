#   Created: Daniel Swain
#   Date: 16/04/2016
#   
#   The Model class for the property listing_image, represents a listing_image
#   
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	listing_image_id: int
#   	listing_image_path: char(128)
#   	listing_image_path_low_res: char(128)
#   	listing_image_created_at: timestamp
#   	listing_image_listing_id: int
#   	
#   Relations:
#   	listing_image_listing_id: ForeignKey relation with the listings table, a single listing_id
#   
#   Todo:
#   	Get relations working so we can go ListingImage.listing and get the associated listing this is for.

class ListingImage < ActiveRecord::Base
	# Not always needed, but if your table name isn't a plural of your model the ActiveRecord
	# Method for grabbing the data will fail as it will look for a table named as the plural of
	# your model file (i.e. listing_statuses not listing_status).
	self.table_name = "listing_images"

	# Relations, note might need to specify foreign_key if we use non-standard column names
	#belongs_to :listing, foreign_key: "listing_id"
end
