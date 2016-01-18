# frozen_string_literal: true
FactoryGirl.define do

  factory :dashboard do
    name 'Example Dashboard'
    key 'example_dashboard'
    password nil

    factory :protected_dashboard do
      password 'secret_password'
    end
  end

end
