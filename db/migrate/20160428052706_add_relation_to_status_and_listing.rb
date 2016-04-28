class AddRelationToStatusAndListing < ActiveRecord::Migration
  def change
  	# Add the foreign_key index to the listings table for the belongs to listing_status_id
  	add_index :listings, :listing_status_id
  end
end
