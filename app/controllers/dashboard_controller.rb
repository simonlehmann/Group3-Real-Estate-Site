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

	# Show the crop avatar page outside of uploading a new image
	def crop
		@user = current_user
		render "dashboard/crop"
	end
end
