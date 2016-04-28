class AddRemainingRelations < ActiveRecord::Migration
  def change
  	# Add the foreign_key index to the listings table for the listing_cover_image_id column
  	add_index :listings, :listing_cover_image_id
  	
  	# Add the foreign_key index to the listing_images table for the listing_image_listing_id
  	add_index :listing_images, :listing_image_listing_id
  	
  	# Add the foreign_key index to the messages table for the message_to_user_id
  	add_index :messages, :message_to_user_id
  	# Add the foreign_key index to the messages table for the message_from_user_id
  	add_index :messages, :message_from_user_id

  	# Add the foreign_key index to the favourites table for the favourite_user_id
  	add_index :favourites, :favourite_user_id
  	# Add the foreign_key index to the favourites table for the favourite_listing_id
  	add_index :favourites, :favourite_listing_id

  	# Add the foreign_key index to the blockages table for the blockage_to_user_id
  	add_index :blockages, :blockage_to_user_id
  	# Add the foreign_key index to the blockages table for the blockage_from_user_id
  	add_index :blockages, :blockage_from_user_id
  end
end
