class AddRelationToTagsAndTagTypes < ActiveRecord::Migration
  def change
  	add_index :tags, :tag_type_id
  end
end
