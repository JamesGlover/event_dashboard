# frozen_string_literal: true
class Warehouse::Role < WarehouseRecord

  ORDER_TYPE_KEY = 'order_type'

  belongs_to :role_type, inverse_of: :roles
  belongs_to :event,     inverse_of: :roles
  belongs_to :subject,   inverse_of: :roles

  has_many :metadata,    through: :event

  has_one :event_type,   through: :event

  delegate :occured_at, to: :event

  # Note that order type data cannot be eager loaded on role alongside
  has_one :order_type_data, :through => :event

  def order_type
    order_type_data.try(:value)
  end
end
