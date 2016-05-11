class SearchController < ApplicationController
	
	include ApplicationHelper
	include SellHelper
	
	def index
		search_suburbs = params[:suburb]
		search_feature = params[:feature]
		search_free = params[:free]
		puts "Suburbs:"
		puts search_suburbs
		puts "Features:"
		puts search_feature
		puts "Free:"
		puts search_free
		#split suburb ids from suburb_0000 and find_by_id
		suburbs_ids =  split_suburbs(search_suburbs)
		suburbs = Location.find_by_id(suburbs_ids).suburb

		@listings = Listing.where(listing_suburb: suburbs)
		puts @listings
	end
	#split suburbs from suburb_0000 to 0000
	def split_suburbs(suburbs_data)
		suburbs = Array.new
		suburbs_data.each{ |sub| suburbs << sub.split("_").last.to_i }
		return suburbs
	end

	def get_search
		@search_data = ActiveSupport::JSON.decode(params[:search_values])
		#build the query yeahhh :sunglasses:
		search_query = build_query(@search_data)
		# if last char is & cuts it off
		puts search_query[-1, 1]
		if search_query[-1, 1] == "&" then search_query.chop! end
		#console output to test if queries gone through
		puts "--->>> #{search_query}"

		respond_to do |format|
			format.js { render :js => "window.location.href = '#{search_path}?#{search_query}'"}
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
