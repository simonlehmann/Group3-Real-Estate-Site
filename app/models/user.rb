#   Created: Daniel Swain
#   Date: 16/04/2016
#   
#   The Model class for the property status, represents a status for a listing
#   
#   Column names in db are as follows (all requried unless specified as NULLABLE):
#   	UserID: int
#   	UserUsername: varchar(32)
#   	UserFirstName: varchar(32)
#   	UserMiddleName: varchar(32) NULLABLE
#   	UserLastName: varchar(32)
#   	UserPassword: varchar(64)
#   	UserEmailAddress: varchar(128)
#   	UserType: set("User", "Staff", "Admin")
#   	UserStatus: set("Active", "PRR", "Inactive") {NB. PRR stands for Password Reset Requested}
#   	UserCreatedAt: datetime
#   	UserUpdatedAt: datetime
#   	
#   Relations:
# 		No foriegn key relations in the user, but others relate to it.

class User < ActiveRecord::Base
	# Not always needed, but if your table name isn't a plural of your model the ActiveRecord
	# Method for grabbing the data will fail as it will look for a table named as the plural of
	# your model file (i.e. listing_statuses not listing_status).
	self.table_name = "users"
end