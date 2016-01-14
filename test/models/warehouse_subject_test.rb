require 'test_helper'

class Warehouse::SubjectTest < ActiveSupport::TestCase

  test 'can be filtered by type' do

    plate = create :plate
    tube = create :tube

    results = Warehouse::Subject.of_type(plate.subject_type)

    assert_includes results, plate
    assert_not_includes results, tube
  end

  test 'can be filtered on present roles' do

    pst = create :plate_subject_type
    source_plate = create :role_type, key: 'source_plate'

    not_started_plate = create :plate, subject_type: pst
    just_started_plate = create :plate, subject_type: pst

    event_type = create :event_type

    create :plate_event, subject: just_started_plate, event_type: event_type, role_type: source_plate

    results = Warehouse::Subject.with_roles(source_plate).with_event_type(event_type).all

    assert_includes results, just_started_plate
    assert_not_includes results, not_started_plate
  end

  test 'can be filtered on absent roles' do

    pst = create :plate_subject_type
    source_plate = create :role_type, key: 'source_plate'

    not_started_plate = create :plate, subject_type: pst
    just_started_plate = create :plate, subject_type: pst
    completed_plate = create :plate, subject_type: pst

    start_event_type = create :event_type
    complete_event_type = create :event_type

    create :plate_event, subject: just_started_plate, event_type: start_event_type, role_type: source_plate

    create :plate_event, subject: completed_plate, event_type: start_event_type, role_type: source_plate
    create :plate_event, subject: completed_plate, event_type: complete_event_type, role_type: source_plate

    results = Warehouse::Subject.with_roles(source_plate).without_event_type(complete_event_type).all

    assert_includes results, not_started_plate
    assert_includes results, just_started_plate
    assert_not_includes results, completed_plate
  end

  test 'can be combined together' do

    pst = create :plate_subject_type
    source_plate = create :role_type, key: 'source_plate'

    not_started_plate = create :plate, subject_type: pst
    just_started_plate = create :plate, subject_type: pst
    completed_plate = create :plate, subject_type: pst

    start_event_type = create :event_type
    complete_event_type = create :event_type

    create :plate_event, subject: just_started_plate, event_type: start_event_type, role_type: source_plate

    create :plate_event, subject: completed_plate, event_type: start_event_type, role_type: source_plate
    create :plate_event, subject: completed_plate, event_type: complete_event_type, role_type: source_plate

    results = Warehouse::Subject.with_roles(source_plate).with_event_type(start_event_type).without_event_type(complete_event_type).all

    assert_includes results, just_started_plate
    assert_not_includes results, not_started_plate
    assert_not_includes results, completed_plate
  end

  test 'doesn\'t pick up other roles' do
    pst = create :plate_subject_type
    source_plate = create :role_type, key: 'source_plate'
    other_plate  = create :role_type, key: 'other_plate'

    just_started_plate = create :plate, subject_type: pst
    irrelevant_plate =   create :plate, subject_type: pst

    event_type = create :event_type

    create :plate_event, subject: just_started_plate, event_type: event_type, role_type: source_plate
    create :plate_event, subject: irrelevant_plate, event_type: event_type, role_type: other_plate

    results = Warehouse::Subject.with_roles(source_plate).with_event_type(event_type).all

    assert_includes results, just_started_plate
    assert_not_includes results, irrelevant_plate
  end

  test 'can filter order_roles' do
    pst = create :plate_subject_type
    source_plate = create :role_type, key: 'source_plate'

    just_started_plate = create :plate, subject_type: pst
    irrelevant_plate =   create :plate, subject_type: pst

    event_type = create :event_type

    meta = create :plate_event, subject: just_started_plate, event_type: event_type, role_type: source_plate
    no_meta = create :plate_event, subject: irrelevant_plate, event_type: event_type, role_type: source_plate

    meta.metadata.create!(key:'order_type',value:'ISC')
    no_meta.metadata.create!(key:'order_type',value:'NOISC')

    results = Warehouse::Subject.with_roles(source_plate).with_event_type(event_type).with_order_type('ISC').all

    assert_includes results, just_started_plate
    assert_not_includes results, irrelevant_plate
  end

end
