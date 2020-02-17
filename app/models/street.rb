class Street < ApplicationRecord
  before_validation :set_slug, :set_display_name

  has_many :provider_streets
  has_many :providers, through: :provider_streets

  has_many :bin_bag_retailer_streets
  has_many :bin_bag_retailers, through: :bin_bag_retailer_streets

  validates :presentation_method, inclusion: { in: %w(bag bin mixed) }
  validates :slug, uniqueness: true

  def self.calculate_all_distances!
    where(presentation_method: %w(bag mixed)).each(&:calculate_nearest_retailers!)
  end

  def nearest_retailers
    self.big_bag_retailers.includes(:bin_bag_retailer_streets).order('bin_bag_retailer_streets.duration_in_seconds').limit(3)
  end

  def nearest_retailer_streets
    return [] unless %w(bag mixed).include? self.presentation_method
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

  def calculate_nearest_retailers!
    return unless %w(bag mixed).include? self.presentation_method
    BinBagRetailer.where.not(id: self.bin_bag_retailers.pluck(:id)).each do |retailer|
      bbrs = BinBagRetailerStreet.find_or_initialize_by(bin_bag_retailer: retailer, street: self)
      bbrs.save!
    end
  end

  private

  def set_slug
    self.slug = "#{ self.postcode } #{ self.name }".downcase.parameterize
  end

  def set_display_name
    self.display_name = "#{ self.name }, Dublin #{ self.postcode }"
  end
end
