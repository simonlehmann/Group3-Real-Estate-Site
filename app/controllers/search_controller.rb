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
		@search_data = ActiveSupport::JSON.decode(params[:search_values])
		#build the query yeahhh :sunglasses:
		search_query = build_query(@search_data)
		# if last char is & cuts it off
		puts search_query[-1, 1]
		if search_query[-1, 1] == "&" then search_query.chop! end
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
		puts search_query
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

		#redirect_to search_path(test: @test)
		respond_to do |format|
			format.js { render :js => "window.location.href = '#{search_path}?{#{search_query}}'"}
		end
	end
	#main query builder/holder
	def build_query(data)
		suburbs = ""
		free = ""
		features = ""
		query = ""

		data.each do |value|
			#iterate through values from search data and create search
			case value
				when /suburb/
					suburbs << build_subterm(suburbs, "suburb", value)
				when /feature/
					features << build_subterm(features, "feature", value)
				else
					free << build_subterm(free, "free", value)
			end
		end
		#return complete combined query back to get_search
		return query << combine_query(suburbs, free, features)

	end
	#build part of the query
	def build_subterm(part_query, type, term)
		#if part_query (suburbs, features or free) insert &, otherwise dont
		return "#{type}[]=#{term}&"
	end
	#combine query terms method
	#add suburbs to query
	def combine_query(suburbs, free, features)
		query = ""
		if suburbs.length != 0
			query << "#{suburbs}"
		end
		#if features has text then put in query
		if features.length != 0
			#if query has text add &, otherwise dont
			if query
				query << "&#{features}"
			else
				query << "#{features}"
			end
		end
		#if free has text then put in query
		if free.length != 0
			#if query has text add &, otherwise dont
			if query
				query << "&#{features}"
			else
				query << "#{free}"
			end
		end
		#return full configured query (build_query)
		return query
	end
end
