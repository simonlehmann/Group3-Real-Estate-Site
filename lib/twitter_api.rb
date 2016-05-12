class TwitterApi
	def self.our_public_tweets
    	client.user_timeline('otir0d', count: 1, exclude_replies: true, include_rts: false)
  	end

  	def self.client
   		@client ||= Twitter::REST::Client.new do |config|
    		config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      		config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      		config.access_token	       = ENV['TWITTER_ACCESS_KEY']
      		config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    	end
  	end
end