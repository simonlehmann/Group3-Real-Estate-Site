class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :address
      t.string :suburb
      t.string :state
      t.integer :post_code
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :parking
      t.integer :land_size
      t.string :title
      t.string :subtitle
      t.string :description
      t.string :price_type
      t.integer :price_min
      t.integer :price_max
      t.datetime :created_at

      t.timestamps null: false
    end
  end
end
