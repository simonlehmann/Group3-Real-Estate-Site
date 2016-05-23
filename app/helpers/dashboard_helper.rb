module DashboardHelper
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
