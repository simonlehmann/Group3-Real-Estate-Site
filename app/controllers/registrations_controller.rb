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
			respond_with resource, location: after_update_path_for(resource)
		else
			clean_up_passwords resource
			flash[:errors] = flash[:notice].to_a.concat resource.errors.full_messages
			redirect_to :dashboard_settings
		end
	end

	# Overriding the default devise method for user creation so we can create a default user avatar for the user
	# This is so they immediately have the ability to crop their icons from the moment they upload a new one as
	# it requires an avatar to exist for it to work. This method is unchanged unless noted
	def create
		build_resource(sign_up_params)
		resource.save
		yield resource if block_given?

		# Now the resource is saved lets add the default profile image to it.
		usericons_path = Rails.root.join("public/usericons/") # Get the path to the usericons folder
		colours = %w( blue green orange pink purple red ) # Word array of colour choices
		pnrg = Random.new # A random generator
		colour = colours[pnrg.rand(0...colours.length)] # Pick a colour from colours randomly
		avatar = File.open(usericons_path.join("usericon_#{colour}.png")) # Open the file
		# Attach the avatar, save the avatar to the new user and then close the file.
		resource.avatar = avatar
		resource.save
		avatar.close

		# Back to normal devise method
		if resource.persisted?
			if resource.active_for_authentication?
				set_flash_message! :notice, :signed_up
				sign_up(resource_name, resource)
				respond_with resource, location: after_sign_up_path_for(resource)
			else
				set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
				expire_data_after_sign_in!
				respond_with resource, location: after_inactive_sign_up_path_for(resource)
			end
		else
			clean_up_passwords resource
			set_minimum_password_length
			respond_with resource
		end
	end

	# Crop Avatar action used to perform the actual image cropping. This is incase we want to do it via a url on mobiles
	# (currently disabled as the action is handled in the update action above by moving the crop selection into a modal on the dashboard#settings page
	# def crop_avatar
	# 	@user = current_user
	# 	# We've added the cropping params to the permitted parameters so lets save them
	# 	if @user.update_attributes(account_update_params)
	# 		flash[:updated] = "Avatar successfully cropped"
	# 		redirect_to :dashboard_settings
	# 	else
	# 		flash[:errors] = "Avatar not changed, there was an error"
	# 		redirect_to :dashboard_settings
	# 	end
	# end
	
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
