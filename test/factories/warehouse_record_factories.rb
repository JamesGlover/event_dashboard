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

  factory :event, class: Warehouse::Event do
    event_type
  end

  factory :event_type, class: Warehouse::EventType do
    key
    description "Straight from our event factory!"
  end

  factory :plate, class: Warehouse::Subject do
    association :subject_type, factory: :plate_subject_type
    friendly_name { generate(:human_barcode) }
    uuid
  end

  factory :subject_type, class: Warehouse::SubjectType do
    key
    description "A subject type"

    factory :plate_subject_type do
      key 'plate'
    end
  end

end
