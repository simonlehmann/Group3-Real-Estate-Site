#   Creator: Daniel Swain
#   Date created: 17/04/2016
#   
#   Helper methods that can be used in sell .erb files to get information

module SellHelper

	# Get the main image for the given listing
	def listing_get_main_image(listing)
		return main_image = ListingImage.find_by_listing_image_id(listing.listing_cover_image_id)
	end

	# Get and return an array of images for the listing
	def listing_get_images(listing)
		return images = ListingImage.where(listing_image_listing_id: listing.listing_id)
	end

	# Try and get the status object
	def listing_get_status_object(listing)
		return status = ListingStatus.find(listing.listing_status_id)
	end

	# Get and return a compiled status for the listing
	def listing_get_status_readable(listing)
		status_object = ListingStatus.find(listing.listing_status_id)
		status_return = ""
		if status_object
			# We should have a status object as this isn't Nil or False
			status_label = status_object.listing_status_label
			if status_label == "Home Open" or status_label == "Auction"
				# Get the date and times and format them how we want them
				# %a = Day (Mon), %d = day (08), %b = Month (Apr), %y = Year (16), %H = hour (13), %M = min (59)
				status_date = Date.parse(status_object.listing_status_date.to_s).strftime("%d %b %y")
				status_start_time = Time.parse(status_object.listing_status_start_time.to_s).strftime("%H:%M")
				status_end_time = Time.parse(status_object.listing_status_end_time.to_s).strftime("%H:%M")
				# Set the return string
				status_return = "#{status_label}: #{status_date}, #{status_start_time} - #{status_end_time}"
			elsif status_label == "None"
				# The status is none so set a "none" text
				status_return = "Click here to set a status"
			else
				# Just send the label as there's no date/times
				status_return = status_label
			end
		else
			# Set status return to blank
			status_return = ""
		end
		# Return the status label
		return status_return
	end

	# return a properly formatted date, need to count for times when the date and time are null/nil
	def listing_get_status_date_readable(listing)
		status_object = ListingStatus.find(listing.listing_status_id)
		if status_object
			if status_object.listing_status_date
				return status_date = Date.parse(status_object.listing_status_date.to_s).strftime("%d/%m/%Y")
			else
				return ""
			end
		else
			return ""
		end
	end

	# Return a properly formatted time, need to count for times when the date and time are null/nil
	def listing_get_status_start_time_readable(listing)
		status_object = ListingStatus.find(listing.listing_status_id)
		if status_object
			if status_object.listing_status_start_time
				return status_start_time = Time.parse(status_object.listing_status_start_time.to_s).strftime("%H:%M")
			else
				return ""
			end
		else
			return ""
		end
	end

	# Return a properly formatted time, need to count for times when the date and time are null/nil
	def listing_get_status_end_time_readable(listing)
		status_object = ListingStatus.find(listing.listing_status_id)
		if status_object
			if status_object.listing_status_end_time
				return status_end_time = Time.parse(status_object.listing_status_end_time.to_s).strftime("%H:%M")
			else
				return ""
			end
		else
			return ""
		end
	end

	# Return the tag_type objects for a particular category
	def add_edit_get_tag_types_for_category(category)
		tags = TagType.where(tag_type_category: category)
		return tags
	end

	# Return a list of tag types that aren't used, this is to ensure no duplicates get added
	def add_edit_get_unused_tag_types(existing_tags, category)
		# Lets get the list of tag_types that we wish to exclude
		tags_to_exclude = []
		existing_tags.each do |tag|
			tags_to_exclude << TagType.find_by_tag_type_id(tag.tag_type_id).tag_type_label
		end
		# If we have tags to exclude then lets grab the remaining from the database, otherwise just get all of them for that category
		if tags_to_exclude.length > 0
			tags = TagType.where(tag_type_category: category).where.not(tag_type_label: tags_to_exclude)
		else
			tags = TagType.where(tag_type_category: category)
		end
		# return the tags that are unused so the user can't insert duplicates
		return tags
	end

	# Return the tags in a more readable format (they're stored in the database with integer values and relations)
	def add_edit_get_readable_tags_collection(tags)
		readable_tags = []
		# Convert each tag to a readable version
		# An option tag requires formmating like follows ["Text", "Value"] and we want [ "Qty Label", "qty_label_category" ]
		# So we need to conver the tags into an array with the formmating above
		tags.each do |tag|
			# Get the tag_label, which we refer to as qty
			qty = tag.tag_label
			# Get the tag type from the TagType database using the tag_type_id stored with the tag, we need this for the Label and Category
			tag_type = TagType.find(tag.tag_type_id)
			# Get the tag type label and category in a readable format
			tag_type_label = tag_type.tag_type_label
			tag_type_category = tag_type.tag_type_category
			# Some logic to change the tag display if it's only a singleton (i.e. qty = 1) and pluralise the tag type label if > 1
			tag_display = qty.to_i > 1 ? "#{qty} #{tag_type_label.pluralize}" : tag_type_label
			# Save the retrieved values in our readable_tags array
			readable_tags << [ tag_display, "#{qty}_#{tag_type_label}_#{tag_type_category}"]
		end
		# Return the formatted tags array list
		return readable_tags
	end
end
