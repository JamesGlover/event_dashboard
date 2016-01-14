# frozen_string_literal: true
FactoryGirl.define do

  factory :product_line do

    name 'Example Product Line'
    dashboard
    role_type
    association :subject_type, factory: :plate_subject_type

    transient do
      product_line_event_type_count 2
    end

    after(:build) do |product_line, evaluator|
      product_line.product_line_event_types = build_list(:product_line_event_type, evaluator.product_line_event_type_count, product_line: product_line)
    end

    factory :product_line_without_events do
      transient do
        product_line_event_type_count 0
      end
    end
  end

end
