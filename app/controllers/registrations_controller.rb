#   Creator: Daniel Swain
#   Date created: 29/04/2016
#   
#   This controller overrides the after_sign_up_path_for method from the inbuilt Devise Registrations Controller
#   This will redirect the user to the dashboard_settings page on successfull sign-up
# 	

class RegistrationsController < Devise::RegistrationsController
	protected

	# Redirect to the dashboard settings page after successful sign up
	# This method takes a path 'path/to/url' or a path helper symbol.
	def after_sign_up_path_for(resource)
		# The user has just signed up so lets send a message (this will dissapear after a page refresh or redirect)
		flash[:just_signed_up] = "Welcome to Propertydome!"
		# Redirect using the dashboard_settings path.
		:dashboard_settings
	end

	# If we make it so the user is :confirmable then we need to override the following method as well
	# after_inactive_sign_up_path_for(resource) (using the same method as above)
end 		
