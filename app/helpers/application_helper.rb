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

	# Return an array of uniq states from the database
	def get_states
		return @locations = Location.find_each().map{|loc| loc.state}.uniq!.sort!
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
