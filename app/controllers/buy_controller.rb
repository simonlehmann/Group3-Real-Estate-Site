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
end
