class SearchController < ApplicationController
	
	include ApplicationHelper
	include SellHelper
	
	def index
		test = params[:test]
		puts "-------- Getting results -------"
		puts test
		suburb = Location.find_by_id(test.split("_").last.to_i).suburb
		puts "--------- I think it's this suburb"
		puts suburb
		puts " ------------- getting from database ----"
		@listings = Listing.where(listing_suburb: suburb)
		puts @listings
		puts "---------------------------------------"
	end

	def get_search
		@test = params[:search_values]
		#redirect_to search_path(test: @test)
		respond_to do |format|
			format.js { render :js => "window.location.href = '#{search_path}?test=#{@test}'"}
		end
	end
end
