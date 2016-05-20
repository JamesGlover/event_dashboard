# frozen_string_literal: true
FactoryGirl.define do

  sequence :human_barcode do |i|
    "DN#{i}"
  end

  sequence :uuid do |i|
    SecureRandom.uuid
  end

  sequence :key do |i|
    "key_#{i}"
  end

  sequence :occured_at do |i|
    DateTime.parse('20150101') + i.days
  end

  factory :event, class: Warehouse::Event do
    event_type
    lims_id 'xxx'
    uuid
    occured_at
    user_identifier 'user'

    factory :plate_event do

      transient do
        subject ''
        role_type ''
        order_type 'example'
      end

      after(:build) do |event,evaluator|
        event.metadata << build(:order_type_metadata, value: evaluator.order_type, event: event)
        event.roles << build(:role, subject: evaluator.subject, event: event, role_type: evaluator.role_type)
      end
    end
  end

  factory :role, class: Warehouse::Role do
    role_type
  end

  factory :role_type, class: Warehouse::RoleType do
    key
    description 'A role type'
  end

  factory :event_type, class: Warehouse::EventType do
    key
    description "Straight from our event factory!"
  end

  factory :metadata, class: Warehouse::Metadatum do
    key 'key'
    value 'value'
    factory :order_type_metadata do
      key 'order_type'
      value 'value'
    end
  end

  factory :subject, class: Warehouse::Subject do
    friendly_name { generate(:human_barcode) }
    uuid

    factory :plate do
      association :subject_type, factory: :plate_subject_type
    end
    factory :tube do
      association :subject_type, factory: :tube_subject_type
    end
  end

  factory :subject_type, class: Warehouse::SubjectType do
    key
    description "A subject type"

    factory :plate_subject_type do
      key 'plate'
    end
    factory :tube_subject_type do
      key 'tube'
    end
  end

end
