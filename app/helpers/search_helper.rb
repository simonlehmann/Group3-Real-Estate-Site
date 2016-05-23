#   Created By: Daniel Swain
#   Date: 22/05/2016
#   
#   Module used in searchhelper
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
end
