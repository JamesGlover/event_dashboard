# frozen_string_literal: true
class ProductLineEventType < ActiveRecord::Base
  belongs_to :product_line, required: true
  belongs_to :event_type, class_name: 'Warehouse::EventType', required: true
  # validates_uniqueness_of :order, scope: :product_line_id

  delegate :key, :description, to: :event_type
  delegate :role_type, :order_type, to: :product_line

  def name
    key.humanize
  end

  def first_stage
    product_line.product_line_event_types.first
  end

  def last?
    self == product_line.product_line_event_types.last
  end

  def filters
    {
      :order_type => order_type,
      :role_type => role_type
    }
  end
end
