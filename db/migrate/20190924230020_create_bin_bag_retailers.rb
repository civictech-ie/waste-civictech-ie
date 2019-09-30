class CreateBinBagRetailers < ActiveRecord::Migration[6.0]
  def change
    create_table :bin_bag_retailers do |t|
      t.text :name
      t.text :address
      t.text :postcode
      t.text :google_map_url
      t.boolean :google_map_has_opening_hours
      t.text :providers, array: true, default: []

      t.timestamps
    end
  end
end
