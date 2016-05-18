module BuyHelper
	# Method to turn links in a tweet into a clickable link instead of plain text
	def parsed_tweet tweet
		_parsed_tweet = tweet.text.dup

		# Turn URL's into clickable links
		tweet.urls.each do |entity|
			html_link = link_to(entity.display_url.to_s, entity.expanded_url.to_s, target: '_blank')
			_parsed_tweet.sub!(entity.url.to_s, html_link)
		end
		# Turn media links into clickable links
		tweet.media.each do |entity|
			html_link = link_to(entity.display_url.to_s, entity.expanded_url.to_s, target: '_blank')
			_parsed_tweet.sub!(entity.url.to_s, html_link)
		end

		_parsed_tweet.html_safe
	end

	# Make twitter date human and UX friendly
	def convert_twitter_date date
		formatted_date = date.strftime('%d %b, %Y')
		return formatted_date
	end

	# Method to make the small twitter image to the large twitter image
	def split_twitter_image image_url
		return image_url.to_s.rpartition('_').first + "_400x400.jpg"
	end
end
