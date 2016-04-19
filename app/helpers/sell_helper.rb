#   Creator: Daniel Swain
#   Date created: 17/04/2016
#   
#   Helper methods that can be used in sell .erb files to get information

module SellHelper

	# Get the main image for the given listing
	def listing_get_main_image(listing)
		return main_image = ListingImage.find(listing.ListingCoverImageID)
	end

	# Get and return an array of images for the listing
	def listing_get_images(listing)
		return images = ListingImage.where(ListingImageListingID: listing.ListingID)
	end

	# Try and get the status object
	def listing_get_status_object(listing)
		return status = ListingStatus.find(listing.ListingStatusID)
	end

	# Get and return a compiled status for the listing
	def listing_get_status_readable(listing)
		status_object = ListingStatus.find(listing.ListingStatusID)
		status_return = ""
		if status_object
			# We should have a status object as this isn't Nil or False
			status_label = status_object.ListingStatusLabel
			if status_label == "Home Open" or status_label == "Auction"
				# Get the date and times and format them how we want them
				# %a = Day (Mon), %d = day (08), %b = Month (Apr), %y = Year (16), %H = hour (13), %M = min (59)
				status_date = Date.parse(status_object.ListingStatusDate.to_s).strftime("%d %b %y")
				status_start_time = Time.parse(status_object.ListingStatusStartTime.to_s).strftime("%H:%M")
				status_end_time = Time.parse(status_object.ListingStatusEndTime.to_s).strftime("%H:%M")
				# Set the return string
				status_return = "#{status_label}: #{status_date}, #{status_start_time} - #{status_end_time}"
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
		status_object = ListingStatus.find(listing.ListingStatusID)
		if status_object
			if status_object.ListingStatusDate
				return status_date = Date.parse(status_object.ListingStatusDate.to_s).strftime("%d/%m/%Y")
			else
				return ""
			end
		else
			return ""
		end
	end

	# Return a properly formatted time, need to count for times when the date and time are null/nil
	def listing_get_status_start_time_readable(listing)
		status_object = ListingStatus.find(listing.ListingStatusID)
		if status_object
			if status_object.ListingStatusStartTime
				return status_start_time = Time.parse(status_object.ListingStatusStartTime.to_s).strftime("%H:%M")
			else
				return ""
			end
		else
			return ""
		end
	end

	# Return a properly formatted time, need to count for times when the date and time are null/nil
	def listing_get_status_end_time_readable(listing)
		status_object = ListingStatus.find(listing.ListingStatusID)
		if status_object
			if status_object.ListingStatusEndTime
				return status_end_time = Time.parse(status_object.ListingStatusEndTime.to_s).strftime("%H:%M")
			else
				return ""
			end
		else
			return ""
		end
	end

	# Return the tag_type objects for a particular category
	def add_edit_get_tag_types_for_category(category)
		tags = TagType.where(TagTypeCategory: category)
		return tags
	end
end
