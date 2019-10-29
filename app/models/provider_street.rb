class ProviderStreet < ApplicationRecord
  belongs_to :street
  belongs_to :provider

  validates :street, presence: true
  validates :provider, presence: true

  scope :overrides_collection, -> { where.not(collection_start: nil) }
  scope :overrides_presentation, -> { where.not(presentation_start: nil) }

  def collection_end
    return nil unless collection_start && collection_duration
    collection_start + collection_duration
  end

  def presentation_end
    return nil unless presentation_start && presentation_duration
    presentation_start + presentation_duration
  end
end
