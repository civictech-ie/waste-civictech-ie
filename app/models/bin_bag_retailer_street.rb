class BinBagRetailerStreet < ApplicationRecord
  belongs_to :bin_bag_retailer
  belongs_to :street
  validates :duration_in_seconds, presence: true
  
  before_save :calculate_duration, if: { self.duration_in_seconds.nil? }

  private

  def calculate_duration
    self.duration_in_seconds = GoogleMapsService.calculate_distance_between(self.bin_bag_retailer, self.street)
  end
end
