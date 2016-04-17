#   Created: Daniel Swain
#   Date: 16/04/2016
#   
#   The Model class for the property listing_image, represents a listing_image
#   
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	ListingImageID: int
#   	ListingImagePath: char(128)
#   	ListingImagePathLowRes: char(128)
#   	ListingImageCreatedAt: timestamp
#   	ListingImageListingID: int
#   	
#   Relations:
#   	ListingImageListingID: ForeignKey relation with the listings table, a single ListingID
#   
#   Todo:
#   	Get relations working so we can go ListingImage.Listing and get the associated listing this is for.

class ListingImage < ActiveRecord::Base
	# Not always needed, but if your table name isn't a plural of your model the ActiveRecord
	# Method for grabbing the data will fail as it will look for a table named as the plural of
	# your model file (i.e. listing_statuses not listing_status).
	self.table_name = "listing_images"

	# Relations, note must specify foreign_key as we use non-standard column names
	#belongs_to :listing, foreign_key: "ListingID"
end
