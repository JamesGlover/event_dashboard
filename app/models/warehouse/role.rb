# frozen_string_literal: true
class Warehouse::Role < WarehouseRecord
  belongs_to :role_type
  belongs_to :event
  has_many :metadata, :through => :event
  has_one :event_type, :through => :event
  belongs_to :subject

  delegate :occured_at, to: :event

  def order_type
    metadata.with_key('order_type').first.value
  end
end
