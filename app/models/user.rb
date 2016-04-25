#   Created: Daniel Swain
#   Date: 16/04/2016
#   
#   The Model class for the property status, represents a status for a listing
#   
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	email: varchar(255)
#   	id: int
#   	encrypted_password: varchar(255)
#   	reset_password_token: varchar(255)
#   	reset_password_sent_at: datetime
#   	remember_created_at: datetime
#   	sign_in_count: int
#   	current_sign_in_at: datetime
#   	last_sign_in_at: datetime
#   	current_sign_in_ip: varchar(255)
#   	last_sign_in_ip: varchar(255)
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
		if password.present? and not password.match(/((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W]).{6,20})/)
			errors.add :password, "must include at least one lowercase letter, one uppercase letter, one digit and one special character."
		end
	end
end
