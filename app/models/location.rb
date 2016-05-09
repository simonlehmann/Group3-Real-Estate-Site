#   Created: Michael White
#   Date: 04/05/2016
#
#   The Model class for a single blockage
#
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	id: int (9)
#   	state: varchar
#   	suburb: varchar
#   	state: varchar

class Location < ActiveRecord::Base
	self.table_name = "locations"

end
