class Provider < ApplicationRecord
  before_validation :set_slug

  private

  def set_slug
    self.slug = self.name.downcase.parameterize
  end
end
