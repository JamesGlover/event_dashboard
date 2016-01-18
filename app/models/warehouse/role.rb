# frozen_string_literal: true
class Warehouse::Role < WarehouseRecord
  belongs_to :role_type
  belongs_to :event
  has_many :metadata, :through => :event
  has_one :event_type, :through => :event
  belongs_to :subject

  delegate :occured_at, to: :event
  has_one :order_type_data, ->() { with_key('order_type') }, :class_name => 'Warehouse::Metadatum', :through => :event

  def order_type
    order_type_data.value
  end
end
