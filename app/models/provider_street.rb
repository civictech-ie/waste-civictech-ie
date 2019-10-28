class ProviderStreet < ApplicationRecord
  belongs_to :street
  belongs_to :provider

  validates :street, presence: true
  validates :provider, presence: true

  validates :collection_start, presence: true
  validates :collection_days, presence: true
  validates :presentation_start, presence: true
  validates :presentation_days, presence: true

  def collection_end
    self.collection_start + self.collection_duration
  end

  def presentation_end
    self.presentation_start + self.presentation_duration
  end
end
