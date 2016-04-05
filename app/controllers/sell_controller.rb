# Creator: Daniel Swain
# Date created: 05/04/2016
# 
# Controller Actions:
# 	index: show the main sell page /sell
# 	new: create a new property /sell/new
# 	create: the POST call to /sell upon successful property
# 	edit: return a html form to edit the property post
# 	update: update the property post
# 	destroy: delete the property.
# 
# To do:
# 	complete actions

class SellController < ApplicationController

	# Show the main sell page view
	# GET /sell
	def index
	end

	# Show the add/edit form ready for user input and adding a new property
	# GET /sell/new
	def new
		redirect_to action: :index
	end

	# Add the property from the completed userform
	# POST /sell
	def create
		redirect_to action: :index
	end

	# Show the add/edit form ready for user input to edit an existing property
	# GET /sell/:id/edit
	def edit
		redirect_to action: :index
	end

	# Update the property from the completed userform
	# PATCH/PUT /sell/:id
	def update
		redirect_to action: :index
	end

	# Delete the selected property from the database
	# DELETE /sell/:id/
	def destroy
		redirect_to action: :index
	end
end
