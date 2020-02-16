class Street < ApplicationRecord
  before_validation :set_slug, :set_display_name

  has_many :provider_streets
  has_many :providers, through: :provider_streets

  has_many :bin_bag_retailer_streets
  has_many :bin_bag_retailers, through: :bin_bag_retailer_streets

  validates :presentation_method, inclusion: { in: %w(bag bin mixed) }
  validates :slug, uniqueness: true

  def calculate_nearest_retailers!
    BinBagRetailer.where.not(id: self.bin_bag_retailers.pluck(:id)).each do |retailer|
      BinBagRetailerStreet.create!(bin_bag_retailer: retailer, street: self)
    end
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

  private

  def set_slug
    self.slug = "#{ self.postcode } #{ self.name }".downcase.parameterize
  end

  def set_display_name
    self.display_name = "#{ self.name }, Dublin #{ self.postcode }"
  end
end
