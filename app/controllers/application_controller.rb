class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	# Required to redirect back to previous page on successfull sign-in/out/up
	after_filter :store_action
	before_filter :get_user_details

	# Store the previous url if it wasn't one of the sign-in/out/up ones (used by devise to redirect after completion of the devise action)
	def store_action
		return unless request.get?
		if (request.path != "/login" &&
			request.path != "/sign_up" &&
			request.path != "/password/new" &&
			request.path != "/password/edit" &&
			request.path != "/confirmation" &&
			request.path != "/sign_out" &&
			request.path != "/edit_account" &&
			!request.xhr?) # don't store ajax calls
			store_location_for(:user, request.fullpath)
		end
	end

	def save_my_previous_url
		# session[:previous_url] is a Rails built-in variable to save last url.
		session[:my_previous_url] = URI(request.referer || '').path
	end

	# Go to the previous url or the root_path after updating your account details using devise's built in form actions
	def after_update_path_for(resource)
		session[:previous_url] || root_path
	end

	# Go to the previous url or the root_path after logging out of the site. (aka the site where the request to logout came from)
	def after_sign_out_path_for(resource)
		# Get the controller of the requesting route
		requesting_route_controller = Rails.application.routes.recognize_path(request.referrer)[:controller]
		# Go back to the refering request on logout unless it was a dashboard site (as the user has logged out) in which case go to root_path.
		requesting_route_controller != "dashboard" ? request.referrer : root_path
	end
end

def get_user_details
	user = current_user
	if user
		@user_type = user.user_type
		@username = user.username if user.username != ""
		@first_name = user.first_name if user.first_name != ""
		@last_name = user.last_name if user.last_name != ""
		@email = user.email
	end
end
