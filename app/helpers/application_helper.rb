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

	# Return an array of unique states from the database
	def get_states
		return @locations = Location.find_each().map{ |loc| loc.state }.uniq!.sort!
	end

	# Return an array of unique state accronyms from the databse
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
	def get_suburbs (state = "Western Australia")
		# Return an array of suburbs, sorted in ascending order
		suburb_objects = Location.where(state: state).order(:suburb)
		@suburbs = []
		suburb_objects.each do |obj|
			@suburbs << "#{obj.suburb}"
		end
		return @suburbs
	end
	# Return an array of postcodes for the chosen state
	def get_postcodes (state = "Western Australia")
		postcode_objects = Location.where(state: state).order(:postcode)
		@postcodes = []
		postcode_objects.each do |obj|
			@postcodes << "#{obj.postcode}"
		end
		return @postcodes
	end

	# Return an array of poscodes from the chosen state + suburb
	def get_postcodes_from_selection( state = "Western Australia", suburb)
		postcode_objects = Location.where(state: state, suburb: suburb).order(:postcode)
		@postcodes = []
		postcode_objects.each do |obj|
			@postcodes << "#{obj.postcode}"
		end
		return @postcodes
	end

	# Return an array of suburbs with postcodes appended
	def get_suburbs_postcodes (state = "Western Australia")
		objects = Location.where(state: state)
		@suburbs_postcodes = []
		objects.each do |object|
			@suburbs_postcodes << "#{object.suburb}, #{object.postcode}"
		end
		return @suburbs_postcodes.sort!
	end
end
