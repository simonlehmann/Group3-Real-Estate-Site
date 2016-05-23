class DashboardController < ApplicationController
	# Make sure user is logged in
	before_action :authenticate_user!

	def index
		redirect_to action: :activity
	end

	# Show the activity tab
	def activity
		# Set the correct tab to be active
		@activity_active = "active"
		# Render the index template (which contains all the tabs)
		render "dashboard/index"
	end

	# Show the messages tab
	def messages
		# Set the correct tab to be active
		@messages_active = "active"
		# Render the index template (which contains all the tabs)
		render "dashboard/index"
	end

	# Show the favourites tab
	def favourites
		# Set the correct tab to be active
		@favourites_active = "active"
		# Render the index template (which contains all the tabs)
		render "dashboard/index"
	end

	# Show the settings tab
	def settings
		# Set the correct tab to be active
		@settings_active = "active"
		# Render the index template (which contains all the tabs)
		render "dashboard/index"
	end

	def get_favourites_address
		user = current_user
		favourites = Favourite.where(favourite_user_id: current_user)
		return favourites[0].favourite_listing_id
	end

	# Show the crop avatar page outside of uploading a new image
	# (Turned off as this action isn't used for the time being.
	# The crop action is now handled on dashboard/settings inside a modal)
	# def crop
	# 	@user = current_user
	# 	render "dashboard/crop"
	# end
	def get_favourites_object_array
		user = current_user
		favourites = Favourite.where(favourite_user_id: current_user)
		return favourites
	end
	def get_listing_details(fav_listing_id)
		listing = Listing.where(listing_id: fav_listing_id)
		return listing
	end
end
