#   Created: Daniel Swain
#   Date: 16/04/2016
#
#   The Model class for the property listing_image, represents a listing_image
#
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	listing_image_id: int
#   	listing_image_listing_id: int
#   	image_file_name: the actual image (string)
#   	image_content_type: string
#   	image_file_size: string
#   	image_updated_at: datetime
#   	user_id: int
#
#   Relations: (how to use): If you have a listing_image object (i.e. listing_image = ListingImage.find(1))
#   then the following methods will return the associated object
#   	listing_image.image_listing - will return the listing object for this listing_image
#   	listing_image.cover_image_listing - will return the listing object for this listing_image (likely to not be used)
#   	listing_image.image_user - will return the user object for this listing_image
#
#   NOTE:
#   	TALK TO DANIEL AND/OR SIMON BEFORE MODIFYING THESE RELATIONS

class ListingImage < ActiveRecord::Base
	# Not always needed, but if your table name isn't a plural of your model the ActiveRecord
	# Method for grabbing the data will fail as it will look for a table named as the plural of
	# your model file (i.e. listing_statuses not listing_status).
	self.table_name = "listing_images"

	# Relations

	# A listing image can only be associated with one listing (it is stored in this table)
	belongs_to :image_listing, class_name: "Listing", inverse_of: :listing_images, foreign_key: "listing_image_listing_id"

	# A listing image can only belong to one user
	belongs_to :image_user, class_name: "User", inverse_of: :user_listing_images, foreign_key: "user_id"

	# A listing cover image can only be associated with one listing (it will be stored in the listing table)
	has_one :cover_image_listing, class_name: "Listing", inverse_of: :listing_cover_image, foreign_key: "listing_cover_image_id"

	# ListingImage has one attached file
	has_attached_file :image, styles: {	large_w: "1080x600#", large: "800x600#", medium_w: "300x200#", medium: "300x300#" }, :default_url => "/images/:style/missing.png"
	# Validate attached image format and size
	validates_attachment :image, presence: true,
		content_type: { content_type: ["image/jpeg", "image/png"] },
		size: { in: 0..2.megabytes }

end
