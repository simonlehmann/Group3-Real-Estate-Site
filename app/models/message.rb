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
#   Relations: (how to use): If you have a message object (i.e. message = Message.find(1)) then the following methods will return the associated object
#   	message.message_to_user - will return the user object this was sent to
#   	message.message_from_user - will return the user object this was sent from
#   	
#   NOTE:
#   	TALK TO DANIEL AND/OR SIMON BEFORE MODIFYING THESE RELATIONS
#

class Message < ActiveRecord::Base
	self.table_name = "messages"

	# Relations

	# A message can only be associated with one to_user (can't refer to the foreign_key here as it won't work if it's set to the stock "id" rails handles it fine without)
	belongs_to :message_to_user, class_name: "User", inverse_of: :messages_to
	# A message can only be associated with one from_user (can't refer to the foreign_key here as it won't work if it's set to the stock "id" rails handles it fine without)
	belongs_to :message_from_user, class_name: "User", inverse_of: :messages_from

end
