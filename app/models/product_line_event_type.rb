# frozen_string_literal: true
class ProductLineEventType < ActiveRecord::Base
  belongs_to :product_line, required: true
  belongs_to :event_type, class_name: 'Warehouse::EventType', required: true

  delegate :key, :description, to: :event_type
end
