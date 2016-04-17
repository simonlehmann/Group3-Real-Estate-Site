#   Created: Daniel Swain
#   Date: 16/04/2016
#   
#   The Model class for the property status, represents a status for a listing
#   
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	ListingStatusID: int
#   	ListingStatusLabel: set("Home Open", "Auction", "Under Offer", "Sold")
#   	ListingStatusDate: date NULLABLE
#   	ListingStatusStartTime: time NULLABLE
#   	ListingStatusEndTime: time NULLABLE
#   	
#   Relations:
# 		No foriegn key relations in the listing_status, but others relate to it.


class ListingStatus < ActiveRecord::Base
	# Not always needed, but if your table name isn't a plural of your model the ActiveRecord
	# Method for grabbing the data will fail as it will look for a table named as the plural of
	# your model file (i.e. listing_statuses not listing_status).
	self.table_name = "listing_status"
end
