require 'test_helper'

class Warehouse::SubjectTest < ActiveSupport::TestCase

  test 'can be filtered by type' do

    plate = create :plate
    tube = create :tube

    results = Warehouse::Subject.of_type('plate')

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

    results = Warehouse::Subject.with_role_in('source_plate',event_type).all

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

    results = Warehouse::Subject.without_role_in('source_plate',complete_event_type).all

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

    results = Warehouse::Subject.with_role_in('source_plate',start_event_type).without_role_in('source_plate',complete_event_type).all

    assert_includes results, just_started_plate
    assert_not_includes results, not_started_plate
    assert_not_includes results, completed_plate
  end

end
