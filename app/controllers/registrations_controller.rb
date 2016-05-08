#   Creator: Daniel Swain
#   Date created: 29/04/2016
#
#   This controller overrides the after_sign_up_path_for method from the inbuilt Devise Registrations Controller
#   This will redirect the user to the dashboard_settings page on successfull sign-up
#

class RegistrationsController < Devise::RegistrationsController

	# Overide the devise update action so it redirects to dashboard_settings if there's an error thereby negating the need for the 
	# default devise registrations edit page
	def update
		self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
		prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

		resource_updated = update_resource(resource, account_update_params)
		yield resource if block_given?
		if resource_updated
			if is_flashing_format?
				flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
				:update_needs_confirmation : :updated
				set_flash_message :notice, flash_key
			end
			sign_in resource_name, resource, bypass: true
			# If there's an avatar present in the params then lets crop it as it's been saved.
			if params[:user][:avatar].present?
				# Get the current user (used in the form in the crop form which is what we're rendering)
				@user = current_user
				render "dashboard/crop"
			else
				# No image, so we've saved the update with no image change, lets go to the after update path which is set below.
				respond_with resource, location: after_update_path_for(resource)
			end	
		else
			clean_up_passwords resource
			flash[:errors] = flash[:notice].to_a.concat resource.errors.full_messages
			redirect_to :dashboard_settings
		end
	end

	# Crop Avatar action used to perform the actual image cropping
	def crop_avatar
		@user = current_user
		# We've added the cropping params to the permitted parameters so lets save them
		if @user.update_attributes(account_update_params)
			flash[:updated] = "Avatar successfully cropped"
			redirect_to :dashboard_settings
		else
			flash[:errors] = "Avatar not changed, there was an error"
			redirect_to :dashboard_settings
		end
	end
	
	protected

	# Redirect to the dashboard settings page after successful sign up
	# This method takes a path 'path/to/url' or a path helper symbol.
	def after_sign_up_path_for(resource)
		# The user has just signed up so lets send a message (this will dissapear after a page refresh or redirect)
		flash[:just_signed_up] = "Welcome to Propertydome!"
		# Redirect using the dashboard_settings path.
		:dashboard_settings
	end

	# Redirect to the dashboard settings page after successful update
	def after_update_path_for(resource)
		# The user has just signed up so lets send a message (this will dissapear after a page refresh or redirect)
		flash[:updated] = "Your changes have been updated successfully."
		# Redirect using the dashboard_settings path.
		:dashboard_settings
	end

	def sign_up_params
		params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
	end

	# Used when updating the user, we require the user object and permit the other
	def account_update_params
		# Edit this to include the params you need to include/permit when updating (devise will handle it)
		params.require(:user).permit(:avatar, :username, :first_name, :last_name, :email, :password, :password_confirmation, :current_password,
			:avatar_original_w, :avatar_original_h, :avatar_box_w, :avatar_aspect, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
	end

	# If we make it so the user is :confirmable then we need to override the following method as well
	# after_inactive_sign_up_path_for(resource) (using the same method as above)
end
