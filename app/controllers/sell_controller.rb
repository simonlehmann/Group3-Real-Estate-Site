#   Creator: Daniel Swain
#   Date created: 05/04/2016
#   
#   Controller Actions:
# 		* index: show the main sell page /sell
# 		* new: create a new property /sell/new
# 		* create: the POST call to /sell upon successful property
# 		* edit: return a html form to edit the property post
# 		* update: update the property post
# 		* update_status: update the listings status using an Ajax call
# 		* destroy: delete the property.
# 	
# 	Private functions/methods:
# 		* require_login: check if a the requesting caller is logged in, if not then redirect to the login path
# 		* listing_params: Ensure only the params we want can be saved when calling update_attributes on a listing object (helps to minimise malicious actions)
# 		* status_params: Ensure only the params we want can be saved when calling update_attributes on a status object (helps to minimise malicious actions)
# 	
# 	
# 	To do:
# 		* DELETE SETTING OF LISTING AS APPROVED IN CREATE METHOD WHEN ADMIN CONSOLE IS UP

class SellController < ApplicationController
	# Enables me to use SellHelper and ApplicationHelper methods in the controller actions (using in update_status)
	include SellHelper
	include ApplicationHelper

	# define a before_action filter for these actions
	before_action :require_login, except: [:index]

	# Show the main sell page view
	# Method: GET
	# URL: /sell
	# Helper: sell_index_path
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
	# Method: GET
	# URL: /sell/new
	# Helper: new_sell_path
	def new
		# Add logic for new stuff
		# Create a new Listing object that will be used by the form to save later
		@listing = Listing.new
		# Set the action descriptor to "Create Listing"
		@action = "Create Listing"
		render "sell/add_edit"
	end

	# Add the property from the completed userform
	# Method: POST
	# URL: /sell
	# Helper: sell_index_path
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

		# ***************** DELETE WHEN ADMIN INTERFACE IS BUILT
		# Temporary code 
		# Set listing as approved
		@listing.listing_approved = true
		# ***************** END DELETE
		
		# Save the listing
		@listing.save

		# --------- Create and save tags
		# Get the listing id (for saving tags)
		@listing_id = @listing.listing_id
		# Add the tags from the additional-tags-list element, only if there are any tags to save
		if params[:additional_tags_list]
			params[:additional_tags_list].each do |new_tag|
				# Get the tag parts (tags are formated 'qty_label_category' or tag_parts[0], tag_parts[1], tag_parts[2])
				tag_parts = new_tag.split('_')
				# Get the tag_type_id from the label and category (need the .first method as the where call only returns the relation, not the object (which .first returns))
				tag_type_id = TagType.where(tag_type_label: tag_parts[1], tag_type_category: tag_parts[2]).first.tag_type_id
				# Save the tag to the database with the tag_type_id, tag_label and tag_listing_id
				tag = Tag.create(tag_type_id: tag_type_id, tag_label: tag_parts[0], tag_listing_id: @listing_id )
			end
		end

		# --------- Create and save the new images
		# Handle the uploading of the new images via Paperclip
		if params[:images]
			params[:images].each do |image|
				ListingImage.create(image: image, listing_image_listing_id: @listing_id, user_id: current_user.id)
			end
		end

		# --------- Redirect back to the index view now we've saved everything (sending a notice message)
		flash[:listing_notice] = "A listing was created for: #{@listing.listing_address}."
		redirect_to action: :index
	end

	# Show the add/edit form ready for user input to edit an existing property
	# Method: GET
	# URL: /sell/:id/edit
	# Helper: edit_sell_path
	def edit
		# Get the listing from the database
		@listing = Listing.find_by_listing_id(params[:id])
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
	# Method: PATCH/PUT
	# URL: /sell/:id
	# Helper: sell_path
	def update
		# Get the listing object to update
		@listing = Listing.find_by_listing_id(params[:id])
		# Get the existing listings approval state
		is_approved = @listing.listing_approved
		# Get the list of tags for the listing object
		@tags = @listing.listing_tags
		# Handle the update using the grouped listing_params to minimise risk of saving other items not associated with  a listing
		if @listing.update_attributes(listing_params)
			# Delete all the tags and add the updated tags (TODO, look at only updating those that don't exist, removing those removed and leaving those that exist)
			@tags.destroy_all
			# Get the listing_id needed to save the tag
			@listing_id = @listing.listing_id
			# Add the tags from the additional-tags-list element, but only if there are any
			if params[:additional_tags_list]
				params[:additional_tags_list].each do |new_tag|
					# Get the tag parts (tags are formated 'qty_label_category' or tag_parts[0], tag_parts[1], tag_parts[2])
					tag_parts = new_tag.split('_')
					# Get the tag_type_id from the label and category (need the .first method as the where call only returns the relation, not the object (which .first returns))
					tag_type_id = TagType.where(tag_type_label: tag_parts[1], tag_type_category: tag_parts[2]).first.tag_type_id
					# Save the tag to the database with the tag_type_id, tag_label and tag_listing_id
					tag = Tag.create(tag_type_id: tag_type_id, tag_label: tag_parts[0], tag_listing_id: @listing_id )
				end
			end
			# Save the listing_approved value with the old value (so it doesn't change an
			# approved listing to nil or false when editting it)
			@listing.listing_approved = is_approved
			@listing.save

			# Record if there were any images previously and if there weren't then make the first image the cover image
			no_images = false
			if ListingImage.where(listing_image_listing_id: @listing_id).size == 0
				no_images = true
			end

			puts "_________#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
			puts no_images

			# Handle the uploading of the new images via Paperclip
			if params[:images]
				params[:images].each do |image|
					ListingImage.create(image: image, listing_image_listing_id: @listing_id, user_id: current_user.id)
				end
			end

			# Update the cover image selection
			if params[:cover_image_id]
				# Check if that image exists
				if ListingImage.exists?(listing_image_id: params[:cover_image_id].to_i)
					# Update the cover image
					@listing.listing_cover_image_id = params[:cover_image_id].to_i
					@listing.save
				end
			elsif no_images
				# There were no images so lets set the cover image to the first one updated
				if cover_image = ListingImage.where(listing_image_listing_id: @listing_id).first
					puts cover_image.listing_image_id
					@listing.listing_cover_image_id = cover_image.listing_image_id
					@listing.save
				end
			end


			# Delete images marked for deletion
			if params[:destroy_images]
				params[:destroy_images].each do |id|
					@listing_image = ListingImage.find_by_listing_image_id(id)
					if @listing_image
						# Lets delete the photo using Paperclip and also delete the record
						@listing_image.image = nil
						@listing_image.save # <- Saving the deletion of the image to delete the file
						# Destroy the listing image associated with that id
						@listing_image.destroy
					end
				end
			end

			# The listing should be updated, so flash success and redirect to action: :index
			flash[:listing_notice] = "The listing information was successfully updated for: #{@listing.listing_address}."
			redirect_to action: :index
		else
			# There was an error saving the listing so send an error message
			flash[:listing_error] = "There was an error updating the listing details for: #{@listing.listing_address}."
			redirect_to action: :index
		end
	end

	# Update the status object via an Ajax call
	# Method: PUT
	# URL: /sell/:id/status
	# Helper: status_sell_path
	def update_status
		@listing = Listing.find_by_listing_id(params[:id])
		@status = @listing.listing_status
		if @status.update_attributes(status_params)
			# Send the updated values back via an ajax js call so we can update the status ribbon without refreshing the page
			@listing_id = @listing.listing_id.to_s
			@label = @status.listing_status_label
			# convert the date and time into dd/mm/yyyy and hh:mm (24 hour time) if the values aren't nil
			@date = Date.parse(@status.listing_status_date.to_s).strftime("%d/%m/%Y") if @status.listing_status_date != nil
			@start_time = Time.parse(@status.listing_status_start_time.to_s).strftime("%H:%M") if @status.listing_status_start_time != nil
			@end_time = Time.parse(@status.listing_status_end_time.to_s).strftime("%H:%M") if @status.listing_status_end_time != nil
			@status_readable = listing_get_status_readable(@listing)
			# this will render the update_status.js.erb file with the variables we have defined above.
			respond_to do |format|
				format.js
			end
		else
			# There was an error saving it, so lets set the listing_notice and redirect to the index view
			flash[:listing_error] = "There was an error saving the changes to your status. Please try again."
			redirect_to action: :index
		end
		# use this line if you want to not refresh the page, but look into re rendering the partial using JS.erb files
		# render nothing: true
	end

	# Update the suburbs from the state selector choice
	def update_suburbs
		@suburbs = get_suburbs(params[:listing_state])
		@postcodes = get_postcodes(params[:listing_state])
		respond_to do |format|
			format.js
		end
	end

	# Update the postcodes from the suburb selector choice
	def update_postcodes
		@postcodes = get_postcodes_from_selection(params[:listing_state], params[:listing_suburb])
		respond_to do |format|
			format.js
		end
	end

	# Delete the selected property from the database
	# Method: DELETE
	# URL: /sell/:id/ 
	# Helper: sell_path
	def destroy
		# Get the listing so we can send a notice message when deleted.
		listing = Listing.find_by_listing_id(params[:id])
		# Destroy the listing found from the params[:id]
		if listing
			listing.destroy
			flash[:listing_notice] = "Successfully deleted the listing for: #{listing.listing_address}."
			redirect_to action: :index
		else
			listing[:listing_error] = "There was an error deleting the selected listing."
			redirect_to action: :index
		end
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

		def status_params
			# Helper method to limit the accessible parameters for the status object to those for the status (as listed in permit())
			params.permit(:listing_status_label, :listing_status_date, :listing_status_start_time,
				:listing_status_end_time)
		end
end
