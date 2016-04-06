#   Creator: Daniel Swain
#   Date created: 05/04/2016
#   
#   Controller Actions:
# 		* index: show the main sell page /sell
# 		* new: create a new property /sell/new
# 		* create: the POST call to /sell upon successful property
# 		* edit: return a html form to edit the property post
# 		* update: update the property post
# 		* destroy: delete the property.
# 	
# 	To do:
# 		complete actions

class SellController < ApplicationController

	# Show the main sell page view
	# GET /sell
	def index
		# For testing, I've set user has property to true and have some fake properties
		user_has_property = true
		if user_has_property
			@properties = []
			20.times do |i|
				property = {
					id: i,
					address: "21 Shackles Street",
					status: "Home open Saturday 10am - 12pm",
					image_path: "300x300.png",
					description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					counts: {
						unhide: [450, "Views"],
						star: [30, "Favourites"],
						comments: [5, "Comments"],
						wait: [6, "Weeks Until Expired"]
					}
				}
				@properties << property
			end
			render template: "sell/manage"
		else
			render template: "sell/index"
		end
	end

	# Show the add/edit form ready for user input and adding a new property
	# GET /sell/new
	def new
		redirect_to action: :index
	end

	# Add the property from the completed userform
	# POST /sell
	def create
		redirect_to action: :index
	end

	# Show the add/edit form ready for user input to edit an existing property
	# GET /sell/:id/edit
	def edit
		redirect_to action: :index
	end

	# Update the property from the completed userform
	# PATCH/PUT /sell/:id
	def update
		redirect_to action: :index
	end

	# Delete the selected property from the database
	# DELETE /sell/:id/
	def destroy
		redirect_to action: :index
	end
end
