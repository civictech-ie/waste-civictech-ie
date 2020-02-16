class CreateBinBagRetailerStreets < ActiveRecord::Migration[6.0]
  def change
    create_table :bin_bag_retailer_streets do |t|
      t.references :bin_bag_retailer, null: false, foreign_key: true
      t.references :street, null: false, foreign_key: true
      t.integer :duration_in_seconds

      t.timestamps
    end
  end
end
