#   Created By: Daniel Swain
#   Date: 22/05/2016
#   
#   Module used in searchhelper
#   
#   Methods:
#   * build_search_pagination_link_text: Build the pagination link string so pagination can start with the correct search terms
#   * get_search_surrounding_suburbs: Get and return an array of suburbs 1 above and 1 below the searched suburbs
#   

module SearchHelper
	# Take the initial @search_suburbs.... and build the pagination link string so we can have correct pagination with our entered search terms
	def build_search_pagination_link_text(suburbs, prices, properties, features)
		query = ""
		# Add the suburbs
		if suburbs
			suburbs.each do |suburb|
				query << "suburb[]=#{suburb}&"
			end
		end
		# Add the prices (either it'll be to the end or first if there's no suburbs)
		if prices
			prices.each do |price|
				query << "price[]=#{price}&"
			end
		end
		# Add the property stuff (either it'll be to the end or first if there's no suburbs)
		if properties
			properties.each do |property|
				query << "property[]=#{property}&"
			end
		end
		# Add the features (either it'll be to the end or first if there's no suburbs)
		if features
			features.each do |feature|
				query << "feature[]=#{feature}&"
			end
		end
		# return the query so we can build the pagination link
		return query
	end

	# Take the initial array of suburbs and return surrounding suburbs
	def get_search_surrounding_suburbs(suburbs, locations_array)
		return_array = []

		# Loop through the search suburbs and get nearby suburbs from the locations_array
		suburbs.each do |suburb|
			# Because locations_array is sorted via postcode, when we get the suburb location in the array, one above and one below will be nearyby suburbs
			# Need to use suburb.id.to_s as the hash contains string values, not integers
			location_of_suburb = locations_array.index { |hash| hash["id"] == suburb.id.to_s }
			# Grab the suburb below
			return_array << locations_array[location_of_suburb - 1] if location_of_suburb > 1
			# Grab the suburb above
			return_array << locations_array[location_of_suburb + 1] if location_of_suburb != locations_array.index(locations_array.last)
		end

		# Return the array of surrounding suburbs
		return return_array
	end
end
