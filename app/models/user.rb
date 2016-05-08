#   Created: Daniel Swain
#   Date: 16/04/2016
#
#   The Model class for the property status, represents a status for a listing
#
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	id: int
# 		profile_image_path: varchar(128), NULLABLE
# 		first_name: varchar(32), NULLABLE
# 		last_name: varchar(32), NULLABLE
# 		username: varchar(64), NULLABLE
# 		email: varchar(255)
# 		user_type: set('User', 'Staff', 'Admin'): default:User
#   	encrypted_password: varchar(255)
#   	reset_password_token: varchar(255), NULLABLE
#   	reset_password_sent_at: datetime, NULLABLE
#   	remember_created_at: datetime, NULLABLE
#   	sign_in_count: int
#   	current_sign_in_at: datetime, NULLABLE
#   	last_sign_in_at: datetime, NULLABLE
#   	current_sign_in_ip: varchar(255), NULLABLE
#   	last_sign_in_ip: varchar(255), NULLABLE
#   	created_at: datetime
#   	updated_at: datetime
#
#   Relations: (how to use): If you have a user object (i.e. user = User.find(1)) then the following methods will return the associated object
#   	user.user_listings - will return all the listings for that user
#   	user.user_listing_images - will return all the listing images for that user
#   	user.messages_to - will return all the messages sent to this user
#   	user.messages_from - will return all the messages sent by this user
#   	user.user_favourites - will return all the favourites saved by this user
#   	user.blockages_to - will return all the blockages to this user
#   	user.blockages_from - will return all the blockages from this user
#
#   NOTE:
#   	TALK TO DANIEL AND/OR SIMON BEFORE MODIFYING THESE RELATIONS

class User < ActiveRecord::Base
	self.table_name = "users"
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :confirmable, :timeoutable, :lockable, :recoverable, :rememberable, :trackable, :validatable

	# Validate the password complexity
	validate :password_complexity
	# Require a password to have one lowercase, one uppercase, one digit and one special character (only for new passwords.)
	def password_complexity
		if password.present? and not password.match(/((?=.*[a-z])(?=.*[A-Z])(?=.*[0-9!@#$%^&*()_\-+=]).{8,20})/)
			errors.add :password, "must include at least one lowercase letter, one uppercase letter and either one digit or one special character."
		end
	end

	# Send confirmation email after user creation
	# after_create :send_admin_mail
	#   def send_admin_mail
	#     UserMailer.send_new_user_message(self).deliver
	#   end

	# Relations
	# NB using destroy instead of delete as Rails will chain the actions (i.e. if a user has a listing and we destroy the user then the listing will be destroyed
	# but it will also call it's destroy associations (i.e. delete the statuses...) this minimises orphaned data)

	# A user can have many listings, but will destroy them all when the user object is deleted
	has_many :user_listings, class_name: "Listing", inverse_of: :listing_user, foreign_key: "listing_user_id", dependent: :destroy

	# A user can have many listing_images, but will destroy them all when the user object is deleted
	has_many :user_listing_images, class_name: "ListingImage", inverse_of: :image_user, foreign_key: "listing_image_id", dependent: :destroy

	# A user can have many messages to them, but will destroy them all when the user object is deleted
	has_many :messages_to, class_name: "Message", inverse_of: :message_to_user, foreign_key: "message_id", dependent: :destroy

	# A user can have many messages from them, but will destroy them all when the user object is deleted
	has_many :messages_from, class_name: "Message", inverse_of: :message_from_user, foreign_key: "message_id", dependent: :destroy

	# A user can have many favourites, but will destroy them all when the user object is deleted
	has_many :user_favourites, class_name: "Favourite", inverse_of: :favourite_user, foreign_key: "favourite_id", dependent: :destroy

	# A user can have many blockages to them, but will destroy them all when the user object is deleted
	has_many :blockages_to, class_name: "Blockage", inverse_of: :blockage_to_user, foreign_key: "blockage_id", dependent: :destroy

	# A user can have many blockages from them, but will destroy them all when the user object is deleted
	has_many :blockages_from, class_name: "Blockage", inverse_of: :blockage_from_user, foreign_key: "blockage_id", dependent: :destroy

	# User avatar (NB. Changed default_url from /avatars to avatars as that was causing problems with papercrop)
	has_attached_file :avatar, styles: {
		thumb: "100x100#",
		medium: "300x300#"
	}, :default_url => "avatars/:style/missing.png"
	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
	
	# To be able to crop the avatar using papercrop
	crop_attached_file :avatar

end
