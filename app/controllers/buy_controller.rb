class BuyController < ApplicationController
	# Enable the use of ApplicationHelper methods in the controller
	include ApplicationHelper

	def index
		#white top nav in header image
		@top_nav = true
	end

	# This is so the root url of the page goes to url/buy
	def root
		redirect_to action: :index
	end

	# AJAX actions
	def update_search_suburbs
		# Get the suburbs based upon the selected state value in the state dropdown and send it via update_search_suburbs.js.erb
		@suburbs = get_suburbs_postcodes(params[:selected_state])
		respond_to do |format|
			format.js
		end
	end
end
