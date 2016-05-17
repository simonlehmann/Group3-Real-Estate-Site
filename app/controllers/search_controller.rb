class SearchController < ApplicationController
	
	include ApplicationHelper
	include SellHelper


	# Parameters: {"search_values"=>"[\"suburb_6998\"]", 
	# 	"price_values"=>"[\"Price_$700,000\"]", 
	# 	"feature_values"=>"[\"Eco Friendly_Grey Water\",\"Heating Cooling_Airconditioning\",\"Leisure_Pay TV\",\"Indoor Features_Alarm\"]", 
	# 	"property_values"=>"[\"Bedrooms_1 Bedroom\",\"Bathrooms_1 Bathroom\",\"Parking_10 Parking Bays\"]"}

	def index
		@search_suburbs = params[:suburb]
		@search_prices = params[:price]
		@search_property = params[:property]
		@search_feature = params[:feature]
		
		#get id and suburb name and get it to the nav bar...i need to get both of these together and unfortunately its a db call
		@suburbs = Location.select('id', 'suburb').where(suburb: @search_suburbs)

		# If we have prices, then build an array of prices to search between
		# i.e. [400000, 500000] will be used to search for properties with price between $400,000 - 500,000
		price_range = []
		if @search_prices
			@search_prices.each { |price| price_range << price }
			# sort so it's lowest to highest (have to send sort block to correctly sort the integers small to big)
			price_range.sort! { |a, b| a.to_i <=> b.to_i }
		end

		# If we have property tags, then build an array of quantities to search between
		# i.e. bathrooms = [1, 3, 6] will be used to search for properties with bathrooms between 1 - 6
		bathrooms = []
		bedrooms = []
		parking = []
		house_type = []
		if @search_property
			@search_property.each do |property|
				# Split it so we know what array to add the quantity to each property search term is of the form:
				# "Category_Qty" or "House Type_Apartment"
				property_split = property.split("_")
				case property_split[0]
				when "Bathrooms"
					bathrooms << property_split.last.to_i
				when "Bedrooms"
					bedrooms << property_split.last.to_i
				when "Parking"
					parking << property_split.last.to_i
				when "House Type"
					house_type << property_split.last
				end
			end
			# Sort the arrays
			bathrooms.sort!
			bedrooms.sort!
			parking.sort!
			house_type.sort!
		end

		# Now, if we have the price_range and property features (bathrooms, bedrooms, parking, house_type) lets search the db
		# We can sort of cheat here :D. By creating a query string if the array exists (has length !=0)
		# Then we can handle an empty array elegantly, without a bunch of if's. We do this by creating a SQL Between search
		# i.e. we can use BETWEEN 100000 AND 100000 if we are searching for an exact value, this further cuts down on loops/code
		# Lastly, if the price_range array length is = 0 then it's empty and the user didn't search for it, so lets set that query to blank
		# This allows us to combine them all into one big SQL query and only have a two database calls!
		price_range_string = price_range.length != 0 ? "listing_price_min BETWEEN #{price_range.first.to_i} AND #{price_range.last.to_i}" : ""
		bathrooms_string = bathrooms.length != 0 ? "listing_bathrooms BETWEEN #{bathrooms.first.to_i} AND #{bathrooms.last.to_i}" : ""
		bedrooms_string = bedrooms.length != 0 ? "listing_bedrooms BETWEEN #{bedrooms.first.to_i} AND #{bedrooms.last.to_i}" : ""
		parking_string = parking.length != 0 ? "listing_parking BETWEEN #{parking.first.to_i} AND #{parking.last.to_i}" : ""

		# Now, because we were a bit cheeky, we can combine all of these (they're either blank or contain valid sql) and have one search query
		# but only if the strings aren't empty as we need to put AND between the non empty strings
		property_search_string = price_range_string != "" ? "#{price_range_string}" : ""
		if bathrooms_string != "" 
			property_search_string += property_search_string.length != 0 ? " AND #{bathrooms_string}" : "#{bathrooms_string}"
		end
		if bedrooms_string != ""
			property_search_string += property_search_string.length != 0 ? " AND #{bedrooms_string}" : "#{bedrooms_string}"
		end
		if parking_string != ""
			property_search_string += property_search_string.length != 0 ? " AND #{parking_string}" : "#{parking_string}"
		end

		# Now we can perform our search query and include the house_type array and suburbs if they exist
		if @search_suburbs
			# We have suburbs so lets include them in the search and handle the extras
			if house_type.length != 0
				# We want to search via house type as well, so lets include that, along with our suburbs, and the price|bathrooms|bedrooms|parking query
				@listings = Listing.where(listing_suburb: @search_suburbs).where(property_search_string).where(listing_type: house_type).order('listing_created_at DESC')
			else
				# We don't want to search via house type as well, so only search with our suburbs, and the price|bathrooms|bedrooms|parking query
				@listings = Listing.where(listing_suburb: @search_suburbs).where(property_search_string).order('listing_created_at DESC')
			end
		else
			# We don't have any suburbs so lets just handle the extras
			if house_type.length != 0
				# We want to search via house type as well, so lets include that, along with the price|bathrooms|bedrooms|parking query
				@listings = Listing.where(property_search_string).where(listing_type: house_type).order('listing_created_at DESC')
			else
				# We don't want to search via house type as well, so only search with the price|bathrooms|bedrooms|parking query
				@listings = Listing.where(property_search_string).order('listing_created_at DESC')
			end
		end
	end

	#split suburbs from suburb_0000 to 0000
	def split_suburbs(suburb_data)
		return suburb = suburb_data.split("_").last.to_i
	end

	# split price from Price_$700,000 to 700000, converting from currency to an integer
	def split_price(price_data)
		return price = price_data.split("_").last.gsub(/[$,]/,'').to_i
	end

	# split features from "Eco Friendly_Grey Water" to "Grey Water"
	def split_feature(feature_data)
		return feature = feature_data.split("_").last
	end

	# split property from "Bedrooms_1 Bedroom" to "Type_QTY" or "Type_Value"
	# This is so we can properly know what the quantity and search column we have to search via in the database
	def split_property(property_data)
		property_split = property_data.split("_")
		property = ""
		case property_split[0]
		when "Bathrooms", "Bedrooms", "Parking"
			# Return the property as "Type_Qty"
			qty = property_split.last.split(" ").first
			property = "#{property_split[0]}_#{qty}"
		when "House Type"
			# return the property data untouched, i.e. "House Type_Apartment"
			property = property_data
		end
		return property
	end

	# Ajax method to get the search params from the search field and additional tags. And then pass this to the search controller
	def get_search
		# Get the search data, price data, property data and feature data from the search params
		@search_data = ActiveSupport::JSON.decode(params[:search_values])
		@price_data = ActiveSupport::JSON.decode(params[:price_values])
		@property_data = ActiveSupport::JSON.decode(params[:property_values])
		@feature_data = ActiveSupport::JSON.decode(params[:feature_values])
		
		#build the query for suburbs, price, property and features
		suburb_query = build_query(@search_data, "suburb")
		price_query = build_query(@price_data, "price")
		property_query = build_query(@property_data, "property")
		feature_query = build_query(@feature_data, "feature")

		# Combine all the sub_queries into one combined query
		search_query = combine_query(suburb_query, price_query, property_query, feature_query)

		# if last char is & cut it off
		search_query.chop! if search_query[-1, 1] == "&"

		# update the url to include the search query, which will route a call to the search#index action
		respond_to do |format|
			format.js { render :js => "window.location.href = '#{search_path}?#{search_query}'"}
		end
	end

	#main query builder/holder
	def build_query(data, category)
		query = ""

		data.each do |value|
			#iterate through values from search data and create search
			#sanitize url
			value.gsub!(/[!@%#^*]/, '')
			case category
			when "suburb"
				#split suburb id from suburb_0000 and find_by_id
				suburb_id = split_suburbs(value)
				#put array of suburb name with id of suburb
				suburb_name = Location.find_by_id(suburb_id).suburb
				query << build_subterm("suburb", suburb_name)
			when "price"
				# Build up a query for the price tags
				price_val = split_price(value)
				query << build_subterm("price", price_val)
			when "property"
				# Build a query for the property tags
				property_val = split_property(value)
				query << build_subterm("property", property_val)
			when "feature"
				# Build a query for the feature tags
				feature_val = split_feature(value)
				query << build_subterm("feature", feature_val)
			end
		end
		#return complete combined query back to get_search for the given category
		return query

	end

	#build part of the query
	def build_subterm(type, term)
		# Return a query string for the given type and search value (term)
		if term.is_a?(Integer)
			# gsub doesn't work on integers
			return "#{type}[]=#{term}&"
		else
			return "#{type}[]=#{term.gsub(/\s/, '+')}&"
		end
	end
	
	#combine query terms method
	#add suburbs to query
	def combine_query(suburbs, prices, properties, features)
		query = ""
		# If there are suburbs then add them to the query
		if suburbs.length != 0
			query << "#{suburbs}"
		end

		# if there are price queries then add them to the query
		if prices.length !=0
			# if query has text then check if last character is & and add prices, else add "&" and prices
			if query.length != 0
				if query[-1,1] == "&"
					query << "#{prices}"
				else
					query << "&#{prices}"
				end
			else
				# We still have a blank query, so lets use the prices to start the query
				query << "#{prices}"
			end
		end

		# if there are property queryies then add them to the query
		if properties.length !=0
			# if query has text then check if last character is & and add properties, else add "&" and properties
			if query.length != 0
				if query[-1,1] == "&"
					query << "#{properties}"
				else
					query << "&#{properties}"
				end
			else
				# We still have a blank query, so lets use the properties to start the query
				query << "#{properties}"
			end
		end

		# if there are feature queryies then add them to the query
		if features.length !=0
			# if query has text then check if last character is & and add features, else add "&" and features
			if query.length != 0
				if query[-1,1] == "&"
					query << "#{features}"
				else
					query << "&#{features}"
				end
			else
				# We still have a blank query, so lets use the features to start the query
				query << "#{features}"
			end
		end
		
		#return full configured query (build_query)
		return query
	end

	def toggle_favourites
		listing_id = params[:listing_id].to_i
		is_favourited = params[:is_favourited]
		user = current_user

		if listing_id.length != 0 and is_favourited == "true"
			
		end

	end
end
