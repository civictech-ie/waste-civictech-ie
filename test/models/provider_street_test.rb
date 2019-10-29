require 'test_helper'

class ProviderStreetTest < ActiveSupport::TestCase
  test "collection end time" do
    provider_street = ProviderStreet.new(
      street: streets(:lennox),
      provider: providers(:keywaste),
      collection_start: 12 * 60 * 60,
      collection_duration: 60 * 60
    )

    assert_equal provider_street.collection_end, 13 * 60 * 60
  end

  test "presentation end time" do
    provider_street = ProviderStreet.new(
      street: streets(:lennox),
      provider: providers(:keywaste),
      presentation_start: 12 * 60 * 60,
      presentation_duration: 60 * 60
    )

    assert_equal provider_street.presentation_end, 13 * 60 * 60
  end
end
