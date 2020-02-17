class BinBagRetailerStreet < ApplicationRecord
  belongs_to :bin_bag_retailer
  belongs_to :street
  validates :duration_in_seconds, presence: true
  validates :bin_bag_retailer, uniqueness: {scope: :street_id}

  before_validation :calculate_duration, if: -> { self.duration_in_seconds.nil? }

  def duration_in_minutes
    (self.duration_in_seconds.to_f / 60).ceil
  end

  private

  def calculate_duration
    self.duration_in_seconds = GoogleMaps.calculate_distance_between(self.bin_bag_retailer, self.street)
  end
end
