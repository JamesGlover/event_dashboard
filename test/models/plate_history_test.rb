require 'test_helper'

class PlateHistoryTest < ActiveSupport::TestCase

  test "can find specific event_types" do
    plate = create :plate

    et_1 = create :event_type
    et_2 = create :event_type
    et_3  = create :event_type

    source_plate = create :role_type

    e1 = create :plate_event, subject: plate, event_type: et_1, role_type: source_plate, order_type: 'type'
    e2 = create :plate_event, subject: plate, event_type: et_2, role_type: source_plate, order_type: 'type'
    e3 = create :plate_event, subject: plate, event_type: et_3, role_type: source_plate, order_type: 'type'

    plate_history = PlateHistory.new(e1.roles.first,e2.roles.first,e3.roles.first)

    assert_equal e2, plate_history.latest(et_2)
  end

  test 'can find a filtered entry from the event_types list' do
    plate = create :plate

    et_1 = create :event_type

    source_plate = create :role_type
    stock_plate = create :role_type

    e1 = create :plate_event, subject: plate, event_type: et_1, role_type: source_plate, order_type: 'type2'
    e2 = create :plate_event, subject: plate, event_type: et_1, role_type: stock_plate, order_type: 'type2'
    e3 = create :plate_event, subject: plate, event_type: et_1, role_type: stock_plate, order_type: 'type1'

    plate_history = PlateHistory.new(e1.roles.first,e2.roles.first,e3.roles.first)

    assert_equal e2, plate_history.latest(et_1,role_type:stock_plate)
    assert_equal e1, plate_history.latest(et_1,role_type:source_plate)
    assert_equal e3, plate_history.latest(et_1,order_type:'type1')
    assert_equal e1, plate_history.latest(et_1,order_type:'type2')
    assert_equal e3, plate_history.latest(et_1,role_type:stock_plate,order_type:'type1')
    assert_equal e2, plate_history.latest(et_1,role_type:stock_plate,order_type:'type2')
    assert_equal nil, plate_history.latest(et_1,role_type:source_plate,order_type:'type1')
    assert_equal e1, plate_history.latest(et_1,role_type:source_plate,order_type:'type2')
  end


  test 'can filter the event_types list' do
    plate = create :plate

    et_1 = create :event_type

    source_plate = create :role_type
    stock_plate = create :role_type

    e1 = create :plate_event, subject: plate, event_type: et_1, role_type: source_plate, order_type: 'type2'
    e2 = create :plate_event, subject: plate, event_type: et_1, role_type: stock_plate, order_type: 'type2'
    e3 = create :plate_event, subject: plate, event_type: et_1, role_type: stock_plate, order_type: 'type1'

    plate_history = PlateHistory.new(e1.roles.first,e2.roles.first,e3.roles.first)

    assert_equal [e2,e3], plate_history.matching(role_type:stock_plate)
    assert_equal [e1], plate_history.matching(role_type:source_plate)
    assert_equal [e3], plate_history.matching(order_type:'type1')
    assert_equal [e1,e2], plate_history.matching(order_type:'type2')
    assert_equal [e3], plate_history.matching(role_type:stock_plate,order_type:'type1')
    assert_equal [e2], plate_history.matching(role_type:stock_plate,order_type:'type2')
    assert_equal [], plate_history.matching(role_type:source_plate,order_type:'type1')
    assert_equal [e1], plate_history.matching(role_type:source_plate,order_type:'type2')
  end

  test 'can work directly from product line event types' do
    plate = create :plate

    et_1 = create :event_type
    source_plate = create :role_type, key: 'library_source_plate'
    pl = create :product_line, name: 'type2', subject_type: plate.subject_type, role_type: source_plate

    pet = create :product_line_event_type, event_type: et_1, product_line: pl

    stock_plate = create :role_type

    e1 = create :plate_event, subject: plate, event_type: et_1, role_type: source_plate, order_type: 'type2'
    e2 = create :plate_event, subject: plate, event_type: et_1, role_type: stock_plate, order_type: 'type2'
    e3 = create :plate_event, subject: plate, event_type: et_1, role_type: stock_plate, order_type: 'type1'

    plate_history = PlateHistory.new(e1.roles.first,e2.roles.first,e3.roles.first)

    assert_equal e1.occured_at, plate_history.entered_stage(pet)

  end

end
