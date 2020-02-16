class Street < ApplicationRecord
  before_validation :set_slug, :set_display_name

  has_many :provider_streets
  has_many :providers, through: :provider_streets

  has_many :bin_bag_retailer_streets
  has_many :bin_bag_retailers, through: :bin_bag_retailer_streets

  validates :presentation_method, inclusion: { in: %w(bag bin mixed) }
  validates :slug, uniqueness: true

  def calculate_nearest_retailers!
    if self.presentation_method == 'bin'
      return true
    end

    BinBagRetailer.where.not(google_maps_address: [nil,'']).where.not(id: self.bin_bag_retailers.pluck(:id)).each do |retailer|
      BinBagRetailerStreet.create!(bin_bag_retailer: retailer, street: self)
    end
  end

  def nearest_retailers
    self.bin_bag_retailer_streets.order('duration_in_seconds asc').limit(3).map(&:bin_bag_retailer)
  end

  def nearest_retailer_streets
    if self.presentation_method == 'bin'
      return []
    end

    self.bin_bag_retailer_streets.order('duration_in_seconds asc').limit(3)
  end

  def to_param
    self.slug
  end

  def searchable_columns
    [:display_name]
  end

  def collection_end
    self.collection_start + self.collection_duration
  end

  def presentation_end
    self.presentation_start + self.presentation_duration
  end

  def google_maps_address
    [self.name, "Dublin", "D#{self.postcode.split(',').first}", "Ireland"].join(', ')
  end

  private

  def set_slug
    self.slug = "#{ self.postcode } #{ self.name }".downcase.parameterize
  end

  def set_display_name
    self.display_name = "#{ self.name }, Dublin #{ self.postcode }"
  end
end
