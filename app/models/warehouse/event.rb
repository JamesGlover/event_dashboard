# frozen_string_literal: true
class Warehouse::Event < WarehouseRecord

  belongs_to :event_type
  has_many :roles, inverse_of: :event
  has_many :subjects, through: :roles, inverse_of: :events
  has_many :metadata, inverse_of: :event

  has_one :order_type_data, ->() { with_key('order_type') }, :class_name => 'Warehouse::Metadatum'

  delegate :>, :<, :>=, :<=, to: :occured_at

  def to_datetime
    occured_at
  end

end
