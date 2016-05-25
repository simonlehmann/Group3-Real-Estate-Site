module DashboardHelper
	# Returns an object array for the users favourites
	def get_favourites_object_array
		user = current_user
		favourites = Favourite.where(favourite_user_id: current_user)
		return favourites
	end
end
