module DashboardHelper
	# Returns an object array for the users favourites
	def get_favourites_object_array
		user = current_user
		favourites = Favourite.where(favourite_user_id: current_user)
		favourites.order("updated_at")
		return favourites
	end

	# Returns the start time of a status with a pre-set format
	def get_start_time (listing)
		status_object = ListingStatus.find(listing.listing_status_id)
		status_start_time = Time.parse(status_object.listing_status_start_time.to_s).strftime("%H:%M")
		return status_start_time
	end

	# Returns the end time of a status with a pre-set format
	def get_end_time (listing)
		status_object = ListingStatus.find(listing.listing_status_id)
		status_start_time = Time.parse(status_object.listing_status_end_time.to_s).strftime("%H:%M")
		return status_start_time
	end

	# Returns how long ago a status was updated
	def get_time_ago (status_update_time)
		time_distance = time_ago_in_words(status_update_time)
		return time_distance + " ago"
	end

	# Returns the date of a status, for example when a home is open with a pre-set format
	def convert_status_date (date)
		formatted_date = date.strftime('%B %d, %Y')
		return formatted_date
	end

	# Returns a user based on user_id provided
	def get_listing_owner (user_id)
		return User.where(id: user_id)[0]
	end
end
