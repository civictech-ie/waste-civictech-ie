class Street < ApplicationRecord
  before_validation :set_slug

  def to_param
    self.slug
  end

  private

  def set_slug
    self.slug = "#{ self.postcode } #{ self.name }".downcase.parameterize
  end
end
