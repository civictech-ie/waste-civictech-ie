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

  test "calculate duration" do
    start_time, start_days = "12:00", ["monday"]
    end_time, end_days = "17:00", ["tuesday"]

    assert_equal StreetImporter.calculate_duration(start_time, start_days, end_time, end_days), 104400
    
    start_time, start_days = "17:15", ["sunday"]
    end_time, end_days = "5:45", ["monday"]

    assert_equal StreetImporter.calculate_duration(start_time, start_days, end_time, end_days), 45000
    
    start_time, start_days = "20:00", ["sunday"]
    end_time, end_days = "00:00", nil

    assert_equal StreetImporter.calculate_duration(start_time, start_days, end_time, end_days), 14400
    
    start_time, start_days = "20:00", ["monday","tuesday","wednesday","thursday","friday"]
    end_time, end_days = "00:00", ["monday","tuesday","wednesday","thursday","friday"]

    assert_equal StreetImporter.calculate_duration(start_time, start_days, end_time, end_days), 14400
    
    start_time, start_days = "18:00", ["monday","tuesday","wednesday","thursday","friday"]
    end_time, end_days = "22:00", ["monday","tuesday","wednesday","thursday","friday"]

    assert_equal StreetImporter.calculate_duration(start_time, start_days, end_time, end_days), 14400
  end
end

