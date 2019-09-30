class ProviderStreet < ApplicationRecord
  belongs_to :street
  belongs_to :provider

  def collection_end
    self.collection_start + self.collection_duration
  end

  def presentation_end
    self.presentation_start + self.presentation_duration
  end
end
