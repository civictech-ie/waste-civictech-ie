require 'test_helper'

class BinBagRetailerImporterTest < ActiveSupport::TestCase
  test "parse providers" do
    provider_cols = ['keywaste',nil,'','greyhound ',' Citywaste']
    providers = BinBagRetailerImporter.parse_providers(provider_cols)

    assert_equal providers.count, 3
    assert providers.include?('citywaste')
  end
end

