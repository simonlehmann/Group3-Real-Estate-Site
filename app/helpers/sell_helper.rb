#   Creator: Daniel Swain
#   Date created: 05/04/2016
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
			# Set status return to Nil
			status_return = Nil
		end
		# Return the status label
		return status_return
	end

	# Used when generating the modals to get the right accordion/checkbox ticked
	def status_get_active_classes(status)
		# Get the status label
		label = status.ListingStatusLabel
		# Set the variables I'm going to use
		home_class = auction_class = under_offer_class = sold_class = ""
		home_checked = auction_checked = under_offer_checked = sold_checked = ""
		# Set the classes based upon the status
		case label
		when "Home Open"
			home_class = "active"
			home_checked = "checked"
		when "Auction"
			auction_class = "active"
			auction_checked = "checked"
		when "Under Offer"
			under_offer_class = "active"
			under_offer_checked = "checked"
		when "Sold"
			sold_class = "active"
			sold_checked = "checked"
		end

		return home_class, home_checked, auction_class, auction_checked, under_offer_class, under_offer_checked, sold_class, sold_checked
	end

	# Used when generating the modals to get the previous value
	def status_get_date_and_times(status)
		# Get the status label
		label = status.ListingStatusLabel
		# Set the variables I'm going to return
		home_date = home_start_time = home_end_time = ""
		auction_date = auction_start_time = auction_end_time = ""
		# Set the values based upon the status
		case label
		when "Home Open"
			home_date = Date.parse(status.ListingStatusDate.to_s).strftime("%d/%m/%Y")
			home_start_time = Time.parse(status.ListingStatusStartTime.to_s).strftime("%H:%M")
			home_end_time = Time.parse(status.ListingStatusEndTime.to_s).strftime("%H:%M")
		when "Auction"
			auction_date = Date.parse(status.ListingStatusDate.to_s).strftime("%d/%m/%Y")
			auction_start_time = Time.parse(status.ListingStatusStartTime.to_s).strftime("%H:%M")
			auction_end_time = Time.parse(status.ListingStatusEndTime.to_s).strftime("%H:%M")
		end
		
		return home_date, home_start_time, home_end_time, auction_date, auction_start_time, auction_end_time
	end

end
