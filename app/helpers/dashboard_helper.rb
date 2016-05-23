module DashboardHelper
	def get_favourites_object_array
		user = current_user
		favourites = Favourite.where(favourite_user_id: current_user)
		return favourites
	end
	def get_favourites_listing_details_address(fav_listing_id)
		address = Listing.where(listing_id: fav_listing_id)
		return address[0].listing_address
	end
end
