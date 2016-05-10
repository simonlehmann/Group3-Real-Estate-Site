#   Created: Daniel Swain
#   Date: 13/04/2016
#   
#   The Model class for the property listings, represents a listing
#   
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	listing_id: int
#   	listing_cover_image_id: int NULLABLE
#   	listing_type: set('House','Apartment','Land')
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
#   	listing_status_id: int NULLABLE
#   	listing_user_id: int
#   	listing_views: int
#   	listing_favourites: int
#   	listing_comments: int
#   	listing_created_at: timestamp CURRENT_TIMESTAMP
#   	listing_updated_at: timestamp ON UPDATE CURRENT TIMESTAMP
#   	listing_to_end_at: timestamp DEFAULT '0000-00-00 00:00:00'
#   	listing_ended_at: timestamp NULLABLE
#   	listing_approved: boolean DEFAULT = NULL, NULLABLE
#   
#   Relations (how to use): If you have a listing object (i.e. listing = Listing.find(1)) then the following methods will return the associated object
#   	listing.listing_tags - will return the tags associated with the listing
#   	listing.listing_status - will return the listing_status object
#   	listing.listing_user - will return the associated user object
#   	listing.listing_images - will return the images associated with the listing
#   	listing.listing_cover_image - will return the cover image listing_image object for the listing
#   	listing.favourites - will return all the favourite objects for this listing
#   	
#   NOTE:
#   	TALK TO DANIEL AND/OR SIMON BEFORE MODIFYING THESE RELATIONS
#   	

class Listing < ActiveRecord::Base
	# Not always needed, but if your table name isn't a plural of your model the ActiveRecord
	# Method for grabbing the data will fail as it will look for a table named as the plural of
	# your model file (i.e. listing_statuses not listing_status).
	self.table_name = "listings"

	# Set the maximum listings to be shown initially (i.e. listings per page)
	paginates_per 5

	# Relations
	# NB using destroy instead of delete as Rails will chain the actions (i.e. if a user has a listing and we destroy the user then the listing will be destroyed
	# but it will also call it's destroy associations (i.e. delete the statuses...) this minimises orphaned data)

	# A listing can have many tags, deleting the listing will delete all the associated tags
	has_many :listing_tags, class_name: "Tag", inverse_of: :listing, foreign_key: "tag_listing_id", dependent: :destroy
	
	# A listing can have only one status (the ListingStatus class is where we set the has_one relationship, we just store it in this table),
	# deleting the listing will delete the associated status object
	belongs_to :listing_status, class_name: "ListingStatus", inverse_of: :status_listing, foreign_key: "listing_status_id", dependent: :destroy
	
	# A listing belongs to only one user (can't refer to the foreign_key here as it won't work if it's set to the stock "id" rails handles it fine without)
	belongs_to :listing_user, class_name: "User", inverse_of: :user_listings
	
	# A listing can have many images, deleting the listing will delete all the images from the listing_images database table (not the files though)
	has_many :listing_images, class_name: "ListingImage", inverse_of: :image_listing, foreign_key: "listing_image_listing_id", dependent: :destroy
	
	# A listing can have one cover image (the ListingImage class is where we set the has_on relationship, we just store it in this table),
	# deleting the listing will delete the associated status object
	belongs_to :listing_cover_image, class_name: "ListingImage", inverse_of: :cover_image_listing, foreign_key: "listing_cover_image_id", dependent: :destroy
	
	# A listing can have many favourites, deleting the listing will delete all the favourites from the favourites database table
	has_many :favourites, class_name: "Favourite", inverse_of: :favourite_listing, foreign_key: "favourite_id", dependent: :destroy

end
