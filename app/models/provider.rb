class Provider < ApplicationRecord
  before_validation :set_slug

  has_many :provider_streets
  has_many :streets, through: :provider_streets

  private

  def set_slug
    self.slug = self.name.downcase.parameterize
  end
end
