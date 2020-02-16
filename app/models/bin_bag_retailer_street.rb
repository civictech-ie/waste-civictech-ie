class BinBagRetailerStreet < ApplicationRecord
  belongs_to :bin_bag_retailer
  belongs_to :street
  validates :duration_in_seconds, presence: true

  before_validation :calculate_duration, if: -> { self.duration_in_seconds.blank? }

  private

  def calculate_duration
    self.duration_in_seconds = GoogleMaps.calculate_distance_between(self.bin_bag_retailer, self.street)
  end
end
