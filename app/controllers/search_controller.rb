class SearchController < ApplicationController
  def index
  	@listings = Listing.where(listing_user_id: 1)
  end
end
