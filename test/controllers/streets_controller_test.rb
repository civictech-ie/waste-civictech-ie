require 'test_helper'

class StreetsControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    street1 = streets(:lennox)
    street2 = streets(:camden)
    get street_url(street1)
   
    assert @response.body.include? street1.name
    assert_not @response.body.include? street2.name
  end
end
