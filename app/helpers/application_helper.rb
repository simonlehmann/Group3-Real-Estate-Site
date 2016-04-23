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
end
