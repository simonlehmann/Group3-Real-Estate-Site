#   Created: Daniel Swain
#   Date: 16/04/2016
#   
#   The Model class for the property status, represents a status for a listing
#   
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	TagTypeID: int
#   	TagTypeLabel: varchar(50)
#   	TagTypeCategory: varchar(25)
#   	
#   Relations:
# 		No foriegn key relations in the tag_type, but tags relates to it.

class TagType < ActiveRecord::Base
	# Not always needed, but if your table name isn't a plural of your model the ActiveRecord
	# Method for grabbing the data will fail as it will look for a table named as the plural of
	# your model file (i.e. tag_types not tag_type).
	self.table_name = "tag_type"
end
