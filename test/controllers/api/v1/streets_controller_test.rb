require 'test_helper'

class Api::V1::StreetsControllerTest < ActionDispatch::IntegrationTest
  test "index" do
    street = streets(:lennox)
    get api_v1_streets_url, as: :json
    
    assert @response.body.include? street.name
  end

  test "show" do
    street1 = streets(:lennox)
    street2 = streets(:camden)
    get api_v1_street_url(street1), as: :json
    
    assert @response.body.include? street1.name
    assert_not @response.body.include? street2.name
  end
end
