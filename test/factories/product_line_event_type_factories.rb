# frozen_string_literal: true
FactoryGirl.define do

  sequence :order do |i|
    i
  end

  factory :product_line_event_type do
    product_line
    order
    tat_time 1
    event_type

    factory :product_line_event_type_start do
      order 0
      association :event_type, factory: :event_type, key: "start_event", description: "The start of the process"
    end

    factory :product_line_event_type_mid do
      order 1
      tat_time 3
      association :event_type, factory: :event_type, key: "mid_event", description: "The middle of the process"
    end

    factory :product_line_event_type_end do
      order 2
      tat_time 0
      association :event_type, factory: :event_type, key: "end_event", description: "The end of the process"
    end

  end

end
