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
#   Relations: (how to use): If you have a tag object (i.e. tag = Tag.find(1)) then the following methods will return the associated object
#   	tag.tag_type - will return the associated tag_type object
#   	tag.listing - will return the associated listing object

class Tag < ActiveRecord::Base
	self.table_name = "tags"

	# Relations
	# A tag can only have one tag type
	belongs_to :tag_type, class_name: "TagType", inverse_of: :tags, foreign_key: "tag_type_id"
	# A tag can only have one listing
	belongs_to :listing, class_name: "Listing", inverse_of: :listing_tags, foreign_key: "listing_id"
	
end
