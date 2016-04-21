#   Created: Daniel Swain
#   Date: 13/04/2016
#   
#   The Model class for the property listings, represents a listing
#   
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	listing_id: int
#   	listing_cover_image_id: int NULLABLE
#   	listing_address: varchar(256)
#   	listing_suburb: varchar(32)
#   	listing_state: set('Australian Capital Territory','New South Wales','Northern Territory','Queensland','South Australia','Tasmania','Victoria','Western Australia')
#   	listing_post_code: int
#   	listing_bedrooms: int
#   	listing_bathrooms: int
#   	listing_parking: int
#   	listing_land_size: int
#   	listing_title: varchar(64)
#   	listing_subtitle: varchar(128)
#   	listing_description: text
#   	listing_price_type: set('F', 'R') DEFAULT='F'
#   	listing_price_min: decimal(12,2)
#   	listing_price_max: decimal(12,2)
#   	listing_status_id: int
#   	listing_user_id: int
#   	listing_views: int
#   	listing_favourites: int
#   	listing_comments: int
#   	listing_created_at: timestamp CURRENT_TIMESTAMP
#   	listing_updated_at: timestamp ON UPDATE CURRENT TIMESTAMP
#   	listing_toEnd_at: timestamp DEFAULT '0000-00-00 00:00:00'
#   	listing_ended_at: timestamp NULLABLE
#   
#   Relations:
#   	listing_cover_image_id: a link to a ListingImage used as the cover image
#   	listing_status_id: a link to the ListingStatus
#   	listing_user_id: a link to the User
#   	listing_image: A Listing has_many links to ListingImages (from the ListingImage end)
#   	
#   Todo:
#   	Get relations working so we can do Listing.listing_images and get all the listing images as well as simlar methods
#   	for status and user

class Listing < ActiveRecord::Base
	# Not always needed, but if your table name isn't a plural of your model the ActiveRecord
	# Method for grabbing the data will fail as it will look for a table named as the plural of
	# your model file (i.e. listing_statuses not listing_status).
	self.table_name = "listings"

	# Set the maximum listings to be shown initially (i.e. listings per page)
	paginates_per 5

	# Relations, note must specify foreign_key as we use non-standard column names
	#belongs_to :user, foreign_key: "UserID"
end
