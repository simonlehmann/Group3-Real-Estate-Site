#   Created: Daniel Swain
#   Date: 16/04/2016
#   
#   The Model class for the property status, represents a status for a listing
#   
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	listing_status_id: int
#   	listing_status_label: set("Home Open", "Auction", "Under Offer", "Sold", "None")
#   	listing_status_date: date NULLABLE
#   	listing_status_start_time: time NULLABLE
#   	listing_status_end_time: time NULLABLE
#   	created_at: datetime (the date it was created, auto created by rails)
#   	updated_at: datetime (the date it was edited, auto created by rails)
#   	
#   Relations: (how to use): If you have a status object (i.e. status = Status.find(1)) then the following methods will return the associated object
#   	status.status_listing - will return the associated listing object
#   	
#   NOTE:
#   	TALK TO DANIEL AND/OR SIMON BEFORE MODIFYING THESE RELATIONS


class ListingStatus < ActiveRecord::Base
	# Not always needed, but if your table name isn't a plural of your model the ActiveRecord
	# Method for grabbing the data will fail as it will look for a table named as the plural of
	# your model file (i.e. listing_statuses not listing_status).
	self.table_name = "listing_status"

	# Relations
	
	# A status can only have one listing (it will be stored in the listing table)
	has_one :status_listing, class_name: "Listing", inverse_of: :listing_status
end
