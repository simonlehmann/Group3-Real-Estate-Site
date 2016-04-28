class AddRelationToTagsAndListing < ActiveRecord::Migration

  def change
  	# Add the foreign_key index to the tags table for the belongs to listing
  	add_index :tags, :tag_listing_id
  end
end
