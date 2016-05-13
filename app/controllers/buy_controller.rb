class BuyController < ApplicationController
	# Enable the use of ApplicationHelper methods in the controller
	include ApplicationHelper
	include SellHelper

	def index
		#white top nav in header image
		@top_nav = true
		#if cookie doesnt exist bake a cookie with ACT as default
		#permanent is 20years
		if !cookies[:state_short]
			cookies.permanent[:state_short] = 'ACT'
			cookies.permanent[:state_long] = 'Australian Capital Territory'
		end
	end

	# This is so the root url of the page goes to url/buy
	def root
		redirect_to action: :index
	end

	# AJAX actions
	def update_search_suburbs
		# Get the suburbs based upon the selected state value in the state dropdown and send it via update_search_suburbs.js.erb
		@suburbs = get_suburbs_postcodes(params[:selected_state])
		#store new cookie with informationa
		cookies.permanent[:state_long] = params[:selected_state]
		cookies.permanent[:state_short] = get_state_short(params[:selected_state])
		respond_to do |format|
			format.js
		end
	end
end
