class AddImageToListingImage < ActiveRecord::Migration
  def self.up
  	# Add the image file attachment defined in listing_image
    change_table :listing_images do |t|
      t.attachment :image
    end

    # Add a reference to the user (i.e. an index) it will create the column as well
    add_reference :listing_images, :user, index: true
  end

  def self.down
  	# Remove the image file attachment defined in listing_image
    drop_attached_file :listing_images, :image

    # Remove the reference
    remove_reference :listing_images, :user, index: true
  end
end
