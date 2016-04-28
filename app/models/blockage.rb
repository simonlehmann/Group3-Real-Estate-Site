#   Created: Daniel Swain
#   Date: 28/04/2016
#
#   The Model class for a single blockage
#
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	blockage_id: int (9)
#   	blockage_to_user_id: int(9)
#   	blockage_from_user_id: int(9)
#   	blockage_created_at: timestamp
#
#   Relations: (how to use): If you have a blockage object (i.e. blockage = Blockage.find(1)) then the following methods will return the associated object
#   	blockage.blockage_to_user - will return the user object for this blockage (the to user)
#   	blockage.blockage_from_user - will return the user object for this blockage (the from user)
#   	
#   NOTE:
#   	TALK TO DANIEL AND/OR SIMON BEFORE MODIFYING THESE RELATIONS

class Blockage < ActiveRecord::Base
	self.table_name = "blockages"

	# Relations
	
	# A blockage object can only be associated with one to_user object (can't refer to the foreign_key here as it won't work if it's set to the stock "id" rails handles it fine without)
	belongs_to :blockage_to_user, class_name: "User", inverse_of: :blockages_to
	
	# A blockage object can only be associated with one from_user object (can't refer to the foreign_key here as it won't work if it's set to the stock "id" rails handles it fine without)
	belongs_to :blockage_from_user, class_name: "User", inverse_of: :blockages_from
end
