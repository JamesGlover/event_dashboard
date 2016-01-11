require 'test_helper'

class ProductLineTest < ActiveSupport::TestCase

  test "should require a name" do
    pl = build :product_line, name: nil
    assert_not pl.valid?
    assert_includes pl.errors.full_messages, 'Name can\'t be blank'
  end

  test "should require a dashboard" do
    pl = build :product_line, dashboard: nil
    assert_not pl.valid?
    assert_includes pl.errors.full_messages, 'Dashboard can\'t be blank'
  end

  test "should have a dashboard" do
    pl = build :product_line
    assert_kind_of Dashboard, pl.dashboard
  end

  test "should have no product_line event types by default" do
    pl = build :product_line
    assert_empty pl.product_line_event_types
  end

  test "should list product_line_event_types in order" do
    pl = create :product_line
    ple_1 = create :product_line_event_type, order: 1, product_line: pl
    ple_2 = create :product_line_event_type, order: 0, product_line: pl
    assert_includes pl.product_line_event_types, ple_1
    assert_includes pl.product_line_event_types, ple_2
    assert_equal ple_2, pl.product_line_event_types.first
    assert_equal ple_1, pl.product_line_event_types.last
  end

  test "should destroy associated product_line_event_types on destruction" do
    pl = create :product_line
    ple_1 = create :product_line_event_type, order: 1, product_line: pl
    ple_2 = create :product_line_event_type, order: 0, product_line: pl
    assert_equal 1, ProductLine.count
    assert_equal 2, ProductLineEventType.count
    pl.destroy
    assert_equal 0, ProductLine.count
    assert_equal 0, ProductLineEventType.count
  end

  test "report should yield an ordered array of event type and associated plates" do
    pl = create :product_line
    ple_1 = create :product_line_event_type_start, product_line: pl
    ple_2 = create :product_line_event_type_mid,   product_line: pl
    ple_3 = create :product_line_event_type_end,   product_line: pl

    not_started_plate = create :plate
    just_started_plate = create :plate
    in_progress_plate = create :plate
    completed_plate = create :plate

    create :event, subject: just_started_plate, event_type: ple_1.event_type

    create :event, subject: in_progress_plate, event_type: ple_1.event_type
    create :event, subject: in_progress_plate, event_type: ple_2.event_type

    create :event, subject: completed_plate, event_type: ple_1.event_type
    create :event, subject: completed_plate, event_type: ple_2.event_type
    create :event, subject: completed_plate, event_type: ple_3.event_type
  end

end
