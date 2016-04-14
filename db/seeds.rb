# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Fake data for the listings, I created 50 fake property listings
50.times do |n|
	Listing.create(address: "#{n}/474 Murray Street", 
		suburb: "Perth", 
		state: "WA", 
		post_code: 6000, 
		bedrooms: 1, 
		bathrooms: 1, 
		parking: 1, 
		land_size: 60, 
		title: "Check out this awesome property", 
		subtitle: "Subtitle", 
		description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
		price_type: "F",
		price_min: 420000,
		price_max: 420000,
		created_at: Time.now + (n * 10)
	)
end