module DashboardHelper
	def get_favourites_address
		user = current_user
		favourites = Favourite.where(favourite_user_id: current_user)
		if favourites.length > 0
			address = Listing.where(listing_id: favourites[0].favourite_listing_id)
			return address[0].listing_address
		end
	end
end
