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
#   Relations:
# 		No foriegn key relations in the user, but others relate to it.

class User < ActiveRecord::Base
	self.table_name = "users"
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
		:recoverable, :rememberable, :trackable, :validatable

	# Validate the password complexity
	validate :password_complexity
	# Require a password to have one lowercase, one uppercase, one digit and one special character (only for new passwords.)
	def password_complexity
		if password.present? and not password.match(/((?=.*[a-z])(?=.*[A-Z])(?=.*[0-9!@#$%^&*()_\-+=]).{8,20})/)
			errors.add :password, "must include at least one lowercase letter, one uppercase letter and either one digit or one special character."
		end
	end
end
