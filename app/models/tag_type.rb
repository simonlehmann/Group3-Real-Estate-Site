#   Created: Daniel Swain
#   Date: 16/04/2016
#   
#   The Model class for the property status, represents a status for a listing
#   
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	tag_type_id: int
#   	tag_type_label: varchar(50)
#   	tag_type_category: varchar(25)
#   	
#   Relations: (how to use): If you have a tag_type object (i.e. tag_type = TagType.find(1)) then the following methods will return the associated object
#   	tag_type.tags - will return the tags associated with that tag type
#
 		
class TagType < ActiveRecord::Base
	# Not always needed, but if your table name isn't a plural of your model the ActiveRecord
	# Method for grabbing the data will fail as it will look for a table named as the plural of
	# your model file (i.e. tag_types not tag_type).
	self.table_name = "tag_type"

	# Relations
	# # NB using destroy instead of delete as Rails will chain the actions (i.e. if a user has a listing and we destroy the user then the listing will be destroyed
	# but it will also call it's destroy associations (i.e. delete the statuses...) this minimises orphaned data)
	
	# A tagtype can have many tags, deleting a tag type will delete all of the associated tags
	has_many :tags, class_name: "Tag", inverse_of: :tag_type, dependent: :destroy
end
