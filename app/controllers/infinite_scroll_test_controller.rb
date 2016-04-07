#   Created: Daniel Swain
#   Date: 07/04/2016
#   
#   Testing out infinite scrolling/pagination.
#   

class InfiniteScrollTestController < ApplicationController
	def infinite_scroll_test
		# Send a large amount of fake data.
		@tests = Test.order(:name).page params[:page]
	end
end
