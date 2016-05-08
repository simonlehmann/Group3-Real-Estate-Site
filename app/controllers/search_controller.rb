class SearchController < ApplicationController
	
	include ApplicationHelper
	include SellHelper
	
	def index
		@listings = Listing.where(listing_user_id: 1)
	end
end
