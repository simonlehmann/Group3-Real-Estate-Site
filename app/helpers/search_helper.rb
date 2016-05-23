#   Created By: Daniel Swain
#   Date: 22/05/2016
#   
#   Module used in searchhelper
#   

module SearchHelper
	
	# Take the initial @search_suburbs.... and build the pagination link string so we can have propery pagination
	def build_search_pagination_link_text(suburbs, prices, properties, features)
		query = ""

		if suburbs
			suburbs.each do |suburb|
				query << "suburb[]=#{suburb}&"
			end
		end

		if prices
			prices.each do |price|
				query << "price[]=#{price}&"
			end
		end

		if properties
			properties.each do |property|
				query << "property[]=#{property}&"
			end
		end

		if features
			features.each do |feature|
				query << "feature[]=#{feature}&"
			end
		end

		return query

	end
end
