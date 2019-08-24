class Street < ApplicationRecord
  before_validation :set_slug, :set_display_name

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
