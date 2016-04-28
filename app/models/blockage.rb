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
#   Relations:
# 		* a blockage refers to the users affected

class Blockage < ActiveRecord::Base
	self.table_name = "blockages"

end
