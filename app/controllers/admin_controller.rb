class AdminController < ApplicationController
	# Make sure user is logged in
	before_action :authenticate_user!

	def index
		# Get the user if it's logged in (a devise convenience method)
		user = current_user
		user_is_admin = false # Default to not being admin, we check for this before rendering the page

		# try and get the listings for the current user if they're logged in.
		if user
			# Check is user is admin
			if @user_type == "Admin"
				# Get pending listings
				@pending = Listing.where(listing_approved: nil).order(:listing_created_at)
				# Get rejected listings
				@rejected = Listing.where(listing_approved: false).order(:listing_created_at)
				# Prepare to get expired listings
				current_date = DateTime.now()
				# Get expired listing
				@expired = Listing.where("listing_to_end_at < ?", current_date).order(:listing_created_at)
				# Set the admin_has_pending boolean to true if the query returns listings.
				if @pending.size > 0 or @rejected.size > 0 or @expired.size > 0
					admin_has_pending = true
				end
				# render the appropriate view depending on whether the user has listings or not.
				if admin_has_pending
					# Render the manage view for the user with their listings
					render "admin/manage"
				else
					#white top nav in header image as there is a banner image
					@top_nav = true
					# No properties so render the index template
					render "admin/index"
				end
			else
				# If user is not admin, display error
				render "admin/permission_error"
			end
		end
	end

	def update
		user = current_user
		# Get the listing object to update
		@listing = Listing.find_by_listing_id(params[:id])
		if @listing.listing_user_id != user.id
			# Update listing
			if @listing.update_attributes(listing_params)
				if @listing.listing_approved == true
					current_date = DateTime.now()
					expiry_date = current_date + (8 * 7)
					@listing.listing_to_end_at = expiry_date
					@listing.save()
				end
				# The listing should be updated, so flash success and redirect to action: :index
				flash[:listing_notice] = "The listing information was successfully updated for: #{@listing.listing_address}."
				redirect_to action: :index
			else
				# There was an error saving the listing so send an error message
				flash[:listing_error] = "There was an error updating the listing details for: #{@listing.listing_address}."
				redirect_to action: :index
			end
		else
			# There was an error saving the listing so send an error message
			flash[:listing_error] = "You are unable to update your own listings."
			redirect_to action: :index
		end
	end


	def destroy
		listing = Listing.find_by_listing_id(params[:id])
		if listing
			listing.destroy
			# The listing should be deleted, so flash success and redirect to action: :index
			flash[:listing_notice] = "Successfully deleted the listing for: #{listing.listing_address}."
			redirect_to action: :index
		else
			# There was an error deleting the listing so send an error message
			flash[:listing_error] = "There was an error deleting the selected listing."
			redirect_to action: :index
		end
	end

	private

		def listing_params
			params.permit(:id, :listing_approved)
		end

end
