#   Created: Daniel Swain
#   Date: 13/04/2016
#   
#   The Model class for the property listings, represents a listing
#   
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	ListingID: int
#   	ListingCoverImageID: int NULLABLE
#   	ListingAddress: varchar(256)
#   	ListingSuburb: varchar(32)
#   	ListingState: set('Australian Capital Territory','New South Wales','Northern Territory','Queensland','South Australia','Tasmania','Victoria','Western Australia')
#   	ListingPostCode: int
#   	ListingBedrooms: int
#   	ListingBathrooms: int
#   	ListingParking: int
#   	ListingLandSize: int
#   	ListingTitle: varchar(64)
#   	ListingSubtitle: varchar(128)
#   	ListingDescription: text
#   	ListingPriceType: set('F', 'R') DEFAULT='F'
#   	ListingPriceMin: decimal(12,2)
#   	ListingPriceMax: decimal(12,2)
#   	ListingStatusID: int
#   	ListingUserID: int
#   	ListingViews: int
#   	ListingFavourites: int
#   	ListingComments: int
#   	ListingCreatedAt: timestamp CURRENT_TIMESTAMP
#   	ListingUpdatedAt: timestamp ON UPDATE CURRENT TIMESTAMP
#   	ListingToEndAt: timestamp DEFAULT '0000-00-00 00:00:00'
#   	ListingEndedAt: timestamp NULLABLE
#   
#   Relations:
#   	ListingCoverImageID: a link to a ListingImage used as the cover image
#   	ListingStatusID: a link to the ListingStatus
#   	ListingUserID: a link to the User
#   	ListingImage: A Listing has_many links to ListingImages (from the ListingImage end)
#   	
#   Todo:
#   	Get relations working so we can do Listing.ListingImages and get all the listing images as well as simlar methods
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
