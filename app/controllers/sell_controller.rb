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

class SellController < ApplicationController

	# Show the main sell page view
	# GET /sell
	def index
		# Get the user if it's logged in (a devise convinience method)
		user = current_user
		user_has_property = false
		# try and get the listings for the current user if they're logged in.
		if user
			# Get the listings through the user_listings association on the currently logged in user object
			@listings = user.user_listings.order(:listing_created_at).page(params[:page])
			# Set the user_has_property boolean to true if the query returns listings.
			user_has_property = true if @listings.size > 0
		end

		# render the appropriate view depending on whether the user has listings or not.
		if user_has_property
			# Render the manage view for the user with their listings
			render "sell/manage"
		else
			#white top nav in header image as there is a banner image
			@top_nav = true
			# No properties so render the index template
			render "sell/index"
		end
	end

	# Show the add/edit form ready for user input and adding a new property
	# GET /sell/new
	def new
		# Add logic for new stuff
		# Create a new Listing object that will be used by the form to save later
		@listing = Listing.new
		# Set the action descriptor to "Create Listing"
		@action = "Create Listing"
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
		@photos = ListingImage.where(listing_image_listing_id: @listing.listing_id)
		# Set the action descriptor to "Save Changes"
		@action = "Save Changes"
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
