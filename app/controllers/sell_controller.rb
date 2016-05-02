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
# 		* Update update method to use images
# 		* Update create method to use actual cover image id rather than the first one
# 		* Implement Destroy method

class SellController < ApplicationController
	# define a before_action filter for these actions
	before_action :require_login, except: [:index]

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
		# --------- Create and save listing
		# Create and save the listing object using the params from the user form (need the listing so we can add the tags too)
		@listing = Listing.new(listing_params)
		
		# Use the current_user to save it in the listing
		@listing.listing_user_id = current_user.id

		# Create and save a blank status object and assign it to the listing
		@status = ListingStatus.create(listing_status_label: "None")
		@listing.listing_status_id = @status.listing_status_id

		# Store the first image as the cover image (will need to change this later)
		@listing.listing_cover_image_id = ListingImage.first.listing_image_id

		# Save the listing
		@listing.save

		# --------- Create and save tags
		# Get the listing id (for saving tags)
		@listing_id = @listing.listing_id
		# Add the tags from the additional-tags-list element
		params[:additional_tags_list].each do |new_tag|
			# Get the tag parts (tags are formated 'qty_label_category' or tag_parts[0], tag_parts[1], tag_parts[2])
			tag_parts = new_tag.split('_')
			# Get the tag_type_id from the label and category (need the .first method as the where call only returns the relation, not the object (which .first returns))
			tag_type_id = TagType.where(tag_type_label: tag_parts[1], tag_type_category: tag_parts[2]).first.tag_type_id
			# Save the tag to the database with the tag_type_id, tag_label and tag_listing_id
			tag = Tag.create(tag_type_id: tag_type_id, tag_label: tag_parts[0], tag_listing_id: @listing_id )
		end
		
		# --------- Redirect back to the index view now we've saved everything
		redirect_to action: :index
	end

	# Show the add/edit form ready for user input to edit an existing property
	# GET /sell/:id/edit
	def edit
		# Get the listing from the database
		@listing = Listing.find(params[:id])
		# Grab the photos for the listing
		@photos = ListingImage.where(listing_image_listing_id: @listing.listing_id)
		# Grab the tags associated with the listing
		@tags = @listing.listing_tags
		# Set the action descriptor to "Save Changes"
		@action = "Save Changes"
		# Render the view
		render "sell/add_edit"
	end

	# Update the property from the completed userform
	# PATCH/PUT /sell/:id
	def update
		# Get the listing object to update
		@listing = Listing.find(params[:id])
		# Get the list of tags for the listing object
		@tags = @listing.listing_tags
		# Handle the update using the grouped listing_params to minimise risk of saving other items not associated with  a listing
		if @listing.update_attributes(listing_params)
			# Delete all the tags and add the updated tags (TODO, look at only updating those that don't exist, removing those removed and leaving those that exist)
			@tags.destroy_all
			# Get the listing_id needed to save the tag
			@listing_id = @listing.listing_id
			# Add the tags from the additional-tags-list element
			params[:additional_tags_list].each do |new_tag|
				# Get the tag parts (tags are formated 'qty_label_category' or tag_parts[0], tag_parts[1], tag_parts[2])
				tag_parts = new_tag.split('_')
				# Get the tag_type_id from the label and category (need the .first method as the where call only returns the relation, not the object (which .first returns))
				tag_type_id = TagType.where(tag_type_label: tag_parts[1], tag_type_category: tag_parts[2]).first.tag_type_id
				# Save the tag to the database with the tag_type_id, tag_label and tag_listing_id
				tag = Tag.create(tag_type_id: tag_type_id, tag_label: tag_parts[0], tag_listing_id: @listing_id )
			end
			# The listing should be updated, so flash success and redirect to action: :index
			flash[:listing_notice] = "Listing was successfully updated"
			redirect_to action: :index
		else
			# There was an error so redirect to edit.
			redirect_to action: :edit
		end
	end

	# Delete the selected property from the database
	# DELETE /sell/:id/
	def destroy
		redirect_to action: :index
	end

	# private methods used by this controller but not accessible outside of it.
	private

		def require_login
			# Redirect to the devise login view if the user tries to perform an action other than index and isn't signed in
			unless user_signed_in?
				# Using :user instead of resource_name as resource_name is a helper method only accessible in views, not controllers.
				redirect_to session_path(:user)
			end
		end

		def listing_params
			# Helper method to limit the accessible parameters for the listing object to those for the listing (as listed in permit())
			# normally listing parameters would be accessed via params[:listing][:listing_state] but there's a risk that unwanted params might be added and
			# could affect the database, so we only permit the ones we want here.
			params.require(:listing).permit(:listing_address, :listing_suburb, :listing_state, :listing_post_code, 
				:listing_bedrooms, :listing_bathrooms, :listing_parking, :listing_land_size, :listing_price_type, 
				:listing_price_min, :listing_price_max, :listing_description, :listing_title, :listing_subtitle)
		end
end
