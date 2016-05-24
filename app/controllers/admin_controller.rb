class AdminController < ApplicationController
  # Make sure user is logged in
  before_action :authenticate_user!

  def index
		# Get the user if it's logged in (a devise convenience method)
		user = current_user
		user_is_admin = false # Default to not being admin, we check for this before rendering the page

		# try and get the listings for the current user if they're logged in.
		if user
			# If we have provided a sort type then lets get the next set of results and sort using the provided sort method
			# An example parameters list is as follows
			#
			# Parameters: {"page"=>"2", "sort_type"=>"4", "is_sort"=>"true", "_"=>"1462789142490"}
			#
			# We need to pass these parameters back through so we can continue retreiving sorted results in our infinite scrolling method using manage.js.erb

      # Check is user is admin
      if @user_type == "Admin"

        if params[:sort_type] and params[:is_sort] == "true"
  				# Reconnect with the params so they get sent through again.
  				@sort_type = params[:sort_type].to_i # The sort type (1, 2, 3, 4 or 5) see update_sort for a description of the choices
  				@sort_method = params[:sort_method].to_s # The sort method (asc or desc (desc = default))
  				@is_sort = true # Change from a string (sent in params) to the boolean required
  				@page = params[:page] # The current active page for the data (so if we've loaded 3/5 pages we still have 10 listings in the server we need to load)
  				# Get a new set of the listings based on the selected sort method
  				@listings = get_sorted_listings(user, @sort_type, @sort_method, params[:page])
  			else
  				# Get the listings through the user_listings association on the currently logged in user object
  				@listings = user.user_listings.order(:listing_created_at).page(params[:page])
  			end
  			# Set the user_has_property boolean to true if the query returns listings.
  			user_has_property = true if @listings.size > 0

        # render the appropriate view depending on whether the user has listings or not.
    		if user_is_admin
    			# Render the manage view for the user with their listings
    			render "admin/manage"
    		else
    			#white top nav in header image as there is a banner image
    			@top_nav = true
    			# No properties so render the index template
    			render "admin/index"
    		end
      else
        render "admin/permission_error"
      end
		end


	end

  # def get_user_details
  # 	user = current_user
  # 	if user
  #     @user_type = user.user_type if user.user_type != ""
  # 		@username = user.username if user.username != ""
  # 		@first_name = user.first_name if user.first_name != ""
  # 		@last_name = user.last_name if user.last_name != ""
  # 		@email = user.email
  # 	end
  # end

end
