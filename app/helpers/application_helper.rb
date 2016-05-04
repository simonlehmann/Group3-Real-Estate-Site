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

	# The following allow us to use the location database
	def get_suburbs (state = "Western Australia")
		return @states = Location.where(state: state).sort!
	end
	def get_postcodes (state = "Western Australia")
		return @postcodes = Location.where(state: state).sort!
	end
	def get_suburbs_postcodes (state = "Western Australia")
		objects = Location.where(state: state)
		@suburbs_postcodes = []
		objects.each do |object|
			@suburbs_postcodes << "#{object.suburb}, #{object.postcode}"
		end
		return @suburbs_postcodes.sort!
	end
end
