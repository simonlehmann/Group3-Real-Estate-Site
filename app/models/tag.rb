#   Created: Daniel Swain
#   Date: 28/04/2016
#
#   The Model class for the property tags, represents a single tag for a listing
#
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	tag_id: int (9)
#   	tag_label: varchar(64)
#   	tag_type_id: int(9)
#   	tag_listing_id: int(9)
#   	tag_created_at: timestamp
#
#   Relations:
# 		* a tag refers to a single tag type in the tag_type_id column (from the tag_type table)
# 		* a tag also refers to a single listing in the tag_listing_id column (from the listing table)
# 		  The tag_listing_id will have it's relationship also defined in the listing_table

class Tag < ActiveRecord::Base
	self.table_name = "tags"

end
