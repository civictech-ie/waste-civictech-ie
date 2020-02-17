class BinBagRetailer < ApplicationRecord
  validates :name, presence: true
  validates :google_maps_address, uniqueness: true, presence: true
  has_many :bin_bag_retailer_streets
  has_many :streets, through: :bin_bag_retailers
end
