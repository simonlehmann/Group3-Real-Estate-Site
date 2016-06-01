class AddTimestampsToListingStatus < ActiveRecord::Migration
  def change
    add_column :listing_status, :created_at, :datetime
    add_column :listing_status, :updated_at, :datetime
  end
end
