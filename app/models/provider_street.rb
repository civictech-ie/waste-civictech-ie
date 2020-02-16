class ProviderStreet < ApplicationRecord
  belongs_to :street
  belongs_to :provider

  validates :street, presence: true
  validates :provider, presence: true

  scope :overrides_collection, -> { where.not(collection_start: nil) }
  scope :overrides_presentation, -> { where.not(presentation_start: nil) }

  def overrides_collection?
    self.collection_start.present?
  end

  def overrides_presentation?
    self.presentation_start.present?
  end
  
  def calculated_presentation_days
    (self.presentation_days && self.presentation_days.many?) ? self.presentation_days : self.street.presentation_days
  end

  def calculated_collection_days
    (self.collection_days && self.collection_days.many?) ? self.collection_days : self.street.collection_days
  end

  def calculated_collection_start
    (self.collection_start || self.street.collection_start)
  end

  def calculated_collection_duration
    (self.collection_duration || self.street.collection_duration)
  end

  def calculated_collection_end
    (self.collection_end || self.street.collection_end)
  end

  def collection_end
    return nil unless collection_start && collection_duration
    collection_start + collection_duration
  end

  def calculated_presentation_start
    (self.presentation_start || self.street.presentation_start)
  end

  def calculated_presentation_duration
    (self.presentation_duration || self.street.presentation_duration)
  end

  def calculated_presentation_end
    (self.presentation_end || self.street.presentation_end)
  end

  def presentation_end
    return nil unless presentation_start && presentation_duration
    presentation_start + presentation_duration
  end
end
