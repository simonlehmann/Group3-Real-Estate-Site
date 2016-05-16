class SearchController < ApplicationController
	
	include ApplicationHelper
	include SellHelper
	def index
		@search_suburbs = params[:suburb]
		search_feature = params[:feature]
		search_free = params[:free]
		puts "Suburbs:"
		puts @search_suburbs
		puts "Features:"
		puts search_feature
		puts "Free:"
		puts search_free
		#get id and suburb name and get it to the nav bar...i need to get both of these together and unfortunately its a db call
		@suburbs = Location.select('id', 'suburb').where(suburb: @search_suburbs)
		#get property listings
		@listings = Listing.where(listing_suburb: @search_suburbs).order('listing_created_at DESC')
		
	end

	#split suburbs from suburb_0000 to 0000
	def split_suburbs(suburb_data)
		return suburbs = suburb_data.split("_").last.to_i
	end

	def get_search
		@search_data = ActiveSupport::JSON.decode(params[:search_values])
		#build the query yeahhh :sunglasses:
		search_query = build_query(@search_data)
		# if last char is & cuts it off
		puts search_query[-1, 1]
		if search_query[-1, 1] == "&" then search_query.chop! end
		#render page with query in url
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
			#sanitize url
			value.gsub!(/[!@%#^*]/, '')
			case value
				when /suburb/
					#split suburb id from suburb_0000 and find_by_id
					suburb_id = split_suburbs(value)
					#put array of suburb name with id of suburb
					suburb_name = Location.find_by_id(suburb_id).suburb
					puts suburb_name
					#put built suburb term into suburbs
					suburbs << build_subterm(suburbs, "suburb", suburb_name)
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
		return "#{type}[]=#{term.gsub(/\s/, '+')}&"
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
