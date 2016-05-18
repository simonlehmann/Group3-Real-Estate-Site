#   Created By Daniel Swain
#   
#   These are helper methods available inside every view regardless of controller.
#   
#   Available methods
#   	* resource_name (devise): enable us to use devise forms outside of the devise controller
#   	* resource (devise): assign a User.new for devise
#   	* devise_mapping (devise)
#   	
#   	* parse_locations_json: DEVELOPMENT ENV ONLY METHOD to parse locations.json into memory for use in the methods below
#   	* get_locations: PRODUCTION ENV ONLY METHOD to read the array from the locations.json from the Rails Cache Store (only available in Prod)
#   	
#   	* get_states: Return an array of State's used for connecting to the database or parsing the locations.json
#   	* get_states_short: Return an array of short state names (i.e ["ACT", "NSW"...])
#   	* get_states_short_long: Return an array of short and long state names (i.e. [["ACT","Australian Capital Territory"], ....])
#   	* get_suburbs(state): Return an array ["Suburb", ...] for the given state (defaults to Western Australia).
#   	* get_postcodes(state): Return an array ["Postcode", ...] for the given state (defaults to Western Australia).
#   	* get_postcodes_from_selection(state, suburb): Return an array ["Postcode", ...] for the given state (defaults to Western Australia) and selected suburb. 
#   	* get_suburbs_postcodes(state): Return an array [["Suburb, Postcode", "suburb_#{id}"], ...] for the given state (defaults to Western Australia).
#   	
#   TODO:
#   	* When moved to production, delete parse_locations_json method and delete the commented blocks from the get_ methods that call it as they aren't req.
#   	* When moved to production, uncomment out the get_locations method and uncomment the blocks in the get_ methods that call it as it will work
#   	

module ApplicationHelper
	# The following allow us to use the devise forms outside of the devise controller
	def resource_name
		:user
	end
	def resource
		@resource ||= User.new
	end
	def devise_mapping
		@devise_mapping ||= Devise.mappings[:user]
	end

	# ----------------- NOTE THIS METHOD IS FOR DEVELOPMENT ENVIRONMENT ONLY
	# Delete this method, or comment it out when we're moving to production
	# 
	# It will Parse the json file and return the resulting array
	def parse_locations_json
		file_path = Rails.root.join("public/locations.json")
		file = File.read(file_path)
		return array = JSON.parse(file)
	end
	# ------------------ THE ABOVE METHOD IS FOR DEVELOPMENT ENVIRONMENT ONLY

	# ----------------- NOTE, This is a method meant for production.
	# This method won't work in Development, caching is turned off in development.
	# Keep the method and turn it on in production by uncommenting the noted line in the other get locations methods
	def get_locations
		if Rails.cache.exist?("locations")
			# Read the locations hash array from the cache and return it
			return @array = Rails.cache.read("locations")
		else
			# Open up and parse the json into an array of hashes and store it in the cache
			file_path = Rails.root.join("public/locations.json")
			file = File.read(file_path)
			array = JSON.parse(file)
			Rails.cache.write("locations", array)
			return @array = Rails.cache.read("locations")
		end
	end

	# Return an array of unique states from the database
	def get_states
		@locations = ["Australian Capital Territory", "New South Wales", "Northern Territory", "Other Territories", "Queensland", "South Australia", "Tasmania", "Victoria", "Western Australia"]
		return @locations #  Use this line if you want it to grab from the database = Location.find_each().map{ |loc| loc.state }.uniq!.sort!
	end

	# Return an array of unique state accronyms from the states_array
	def get_states_short
		# Get the unique list of long states
		locations = get_states()
		# We're going to take the first letter of each word in the state title and save it to the @states_short array
		@states_short = []
		locations.each do |state|
			temp_short = ""
			# Handle edge cases with one word state names
			case state
			when "Queensland"
				temp_short = "QLD"
			when "Victoria"
				temp_short = "VIC"
			when "Tasmania"
				temp_short = "TAS"
			else
				temp_array = state.split(" ")
				temp_array.each do |word|
					# Grab the first character and upcase it in case it's not
					temp_short += word[0].upcase
				end
			end
			# Add the acronym to the list
			@states_short << temp_short
		end
		# Return the array of state accronyms
		return @states_short
	end

	#return shortended state
	def get_state_short(state)
		temp_short = ""
		case state
		when "Queensland"
			temp_short = "QLD"
		when "Victoria"
			temp_short = "VIC"
		when "Tasmania"
			temp_short = "TAS"
		else
			temp_array = state.split(" ")
			temp_array.each do |word|
				# Grab the first character and upcase it in case it's not
				temp_short += word[0].upcase
			end
		end
		return temp_short
	end

	# Return a 2D array useful for dropdowns that have a short display text but long value required for the database calls
	# a states_short_long is formatted like this ["ACT", "Australian Capital Territory"] or in a [text, value] format used for select_tags
	def get_states_short_long
		# Get the unique list of long states
		locations = get_states()
		# We're going to append 2d arrays into this one and return it, arrays are formated as ["ACT", "Australian Capital Territory"] or [short, long]
		@states_short_long = []
		locations.each do |state|
			temp_short = ""
			# Handle edge cases with one word state names
			case state
			when "Queensland"
				temp_short = "QLD"
			when "Victoria"
				temp_short = "VIC"
			when "Tasmania"
				temp_short = "TAS"
			else
				temp_array = state.split(" ")
				temp_array.each do |word|
					# Grab the first character and upcase it in case it's not
					temp_short += word[0].upcase
				end
			end
			# Add the accronym and the long state value (in this case obj) to the @states_short_long array
			@states_short_long << [ temp_short, state ]
		end
		# return the array of arrays of state acronyms and long values
		return @states_short_long
	end

	# Return an array of suburbs for the chosen state
	def get_suburbs(state = "Western Australia")
		# ---------- Uncomment the array = get_locations() line below when in production
		# array = get_locations() # Get the array from the cache, or load it in memory if it isn't in the cache
		
		# <<<<<<<<<< DELETE THESE LINES IN PRODUCTION (below)
		array = parse_locations_json()
		if !array and !array.size > 0
			array = false
		end
		# >>>>>>>>>>> DELETE THESE LINES IN PRODUCTION (above)
		
		# Empty return array used to store results from selection
		@return_array = []
		# If we got an array from the cache (commented out above in dev as it only works in production environment)
		# then get and return the list of suburbs and postcodes for the chosen state
		if array
			array.each do |obj|
				@return_array << "#{obj["suburb"]}" if obj["state"] == state
			end
		# Else, lets use the old way of getting from the database
		else
			suburb_objects = Location.where(state: state).order(:suburb)
			suburb_objects.each do |obj|
				@return_array << "#{obj.suburb}"
			end
		end
		return @return_array.sort!
	end

	# Return an array of postcodes for the chosen state
	def get_postcodes(state = "Western Australia")
		# ---------- Uncomment the array = get_locations() line below when in production
		# array = get_locations() # Get the array from the cache, or load it in memory if it isn't in the cache
		
		# <<<<<<<<<< DELETE THESE LINES IN PRODUCTION (below)
		array = parse_locations_json()
		if !array and !array.size > 0
			array = false
		end
		# >>>>>>>>>>> DELETE THESE LINES IN PRODUCTION (above)
		
		# Empty return array used to store results from selection
		@return_array = []
		# If we got an array from the cache (commented out above in dev as it only works in production environment)
		# then get and return the list of suburbs and postcodes for the chosen state
		if array
			array.each do |obj|
				@return_array << "#{obj["postcode"]}" if obj["state"] == state
			end
		# Else, lets use the old way of getting from the database
		else
			postcode_objects = Location.where(state: state).order(:postcode)
			postcode_objects.each do |obj|
				@return_array << "#{obj.postcode}"
			end
		end
		# Return a sorted list
		return @return_array.sort!
	end

	# Return an array of poscodes from the chosen state + suburb
	def get_postcodes_from_selection(state = "Western Australia", suburb)
		# ---------- Uncomment the array = get_locations() line below when in production
		# array = get_locations() # Get the array from the cache, or load it in memory if it isn't in the cache
		
		# <<<<<<<<<< DELETE THESE LINES IN PRODUCTION (below)
		array = parse_locations_json()
		if !array and !array.size > 0
			array = false
		end
		# >>>>>>>>>>> DELETE THESE LINES IN PRODUCTION (above)
		
		# Empty return array used to store results from selection
		@return_array = []
		# If we got an array from the cache (commented out above in dev as it only works in production environment)
		# then get and return the list of suburbs and postcodes for the chosen state
		if array
			array.each do |obj|
				if obj["state"] == state and obj["suburb"] == suburb
					@return_array << "#{obj["postcode"]}" 
				end
			end
		# Else, lets use the old way of getting from the database
		else
			postcode_objects = Location.where(state: state, suburb: suburb).order(:postcode)
			postcode_objects.each do |obj|
				@return_array << "#{obj.postcode}"
			end
		end
		# Return a sorted list
		return @return_array.sort!
	end

	# Get the suburbs and postcodes in a nice list formatted as ["Suburb, postcode", "key_for_search"] i.e. ["Perth (WA), 6000", "suburb_1"]
	# The key will be helpful in search to know that this selection refers to an exact suburb and postcode
	def get_suburbs_postcodes(state = "Western Australia")
		# ---------- Uncomment the array = get_locations() line below when in production
		# array = get_locations() # Get the array from the cache, or load it in memory if it isn't in the cache
		
		# <<<<<<<<<< DELETE THESE LINES IN PRODUCTION (below)
		array = parse_locations_json()
		if !array and !array.size > 0
			array = false
		end
		# >>>>>>>>>>> DELETE THESE LINES IN PRODUCTION (above)
		
		# Empty return array used to return results from state selection
		@return_array = []
		# If we got an array from the cache (commented out above in dev as it only works in production environment)
		# then get and return the list of suburbs and postcodes for the chosen state
		if array
			array.each do |obj|
				@return_array << [ "#{obj["suburb"]}, #{obj["postcode"]}", "suburb_#{obj["id"]}" ] if obj["state"] == state
			end
		# Else, lets use the old way of getting from the database
		else
			objects = Location.where(state: state)
			objects.each do |obj|
				@return_array << [ "#{obj.suburb}, #{obj.postcode}", "suburb_#{obj.id}" ]
			end
		end
		# Return a sorted list
		return @return_array.sort!
	end

	# Method to turn links in a tweet into a clickable link instead of plain text
	def parsed_tweet tweet
		_parsed_tweet = tweet.text.dup

		# Turn URL's into clickable links
		tweet.urls.each do |entity|
			html_link = link_to(entity.display_url.to_s, entity.expanded_url.to_s, target: '_blank')
			_parsed_tweet.sub!(entity.url.to_s, html_link)
		end
		# Turn media links into clickable links
		tweet.media.each do |entity|
			html_link = link_to(entity.display_url.to_s, entity.expanded_url.to_s, target: '_blank')
			_parsed_tweet.sub!(entity.url.to_s, html_link)
		end

		_parsed_tweet.html_safe
	end

	# Make twitter date human and UX friendly
	def convert_twitter_date date
		formatted_date = date.strftime('%d %b, %Y')
		return formatted_date
	end
end
