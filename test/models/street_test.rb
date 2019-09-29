require 'test_helper'

class StreetTest < ActiveSupport::TestCase
  test "collection end time" do
    street = Street.new(
      name: 'Lennox Street',
      collection_start: 12 * 60 * 60,
      collection_duration: 60 * 60
    )

    assert_equal street.collection_end, 13 * 60 * 60
  end

  test "presentation end time" do
    street = Street.new(
      name: 'Lennox Street',
      presentation_start: 12 * 60 * 60,
      presentation_duration: 60 * 60
    )

    assert_equal street.presentation_end, 13 * 60 * 60
  end
end