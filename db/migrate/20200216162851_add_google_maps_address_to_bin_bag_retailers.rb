class AddGoogleMapsAddressToBinBagRetailers < ActiveRecord::Migration[6.0]
  def change
    add_column :bin_bag_retailers, :google_maps_address, :text
  end
end
