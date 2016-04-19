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
# 		* complete actions
# 		* Actually check if a user has a property

class SellController < ApplicationController

	# Show the main sell page view
	# GET /sell
	def index
		# For testing, let's say the user has a property
		user_has_property = true
		if user_has_property
			# For testing, I'm using a random user from the database
			testing_user = User.find(1)
			
			# Grab the listings for the user (change the listing order if you want)
			@listings = Listing.where(ListingUserID: testing_user.UserID).order(:ListingCreatedAt).page(params[:page])
			render "sell/manage"
		else
			# No properties so render the index template
			render "sell/index"
		end
	end

	# Show the add/edit form ready for user input and adding a new property
	# GET /sell/new
	def new
		# Add logic for new stuff		
		render "sell/add_edit"
	end

	# Add the property from the completed userform
	# POST /sell
	def create
		redirect_to action: :index
	end

	# Show the add/edit form ready for user input to edit an existing property
	# GET /sell/:id/edit
	def edit
		# Get the listing from the database
		@listing = Listing.find(params[:id])
		# Grab the photos for the listing
		@photos = ListingImage.where(ListingImageListingID: @listing.ListingID)
		# Render the view
		render "sell/add_edit"
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
