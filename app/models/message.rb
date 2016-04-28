#   Created: Daniel Swain
#   Date: 28/04/2016
#
#   The Model class for the user messages, represents a single message object
#
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	message_id: int (9)
#   	message_to_user_id: int(9)
#   	message_from_user_id: int(9)
#   	message_subject: varchar(128)
#   	message_text: text
#   	message_sent_at: timestamp
#
#   Relations:
# 		* a message refers to the sending and receiving users

class Message < ActiveRecord::Base
	self.table_name = "messages"

end
