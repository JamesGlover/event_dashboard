require 'test_helper'

class ProductLineEventTYpeTest < ActiveSupport::TestCase
  test "ProductLineEventTypes delegate to the event type" do
    plet = create :product_line_event_type_mid
    assert_equal 3, plet.turn_around_time
    assert_equal 'mid_event', plet.key
    assert_equal "The middle of the process", plet.description
  end
end
