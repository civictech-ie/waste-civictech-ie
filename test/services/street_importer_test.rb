require 'test_helper'

class StreetImporterTest < ActiveSupport::TestCase
  test "parse boolean" do
    truthy_val = "Y"
    falsy_val = nil

    assert StreetImporter.parse_boolean(truthy_val)
    assert_not StreetImporter.parse_boolean(falsy_val)
  end

  test "parse days" do
    array_val = "[Monday, Tuesday]"
    single_val = "Monday"

    assert_equal StreetImporter.parse_days(array_val), ['monday','tuesday']
    assert_equal StreetImporter.parse_days(single_val), ['monday']
  end

  test "parse time of day" do
    seven_pm = "19:00"
    quarter_past = "19:15"

    assert_equal StreetImporter.parse_time_of_day(seven_pm), 68400
    assert_equal StreetImporter.parse_time_of_day(quarter_past), 69300
  end
end

