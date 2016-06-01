# Add datetime timestamp columns to listing_status table
class AddTimestampsToStatus < ActiveRecord::Migration
	# def change_table
	# 	add_column(:listing_status, :created_at, :datetime)
	# 	add_column(:listing_status, :updated_at, :datetime)
	# end
	def change
		add_timestamps(:listing_status)
	end
end
