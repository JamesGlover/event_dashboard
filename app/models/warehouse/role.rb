# frozen_string_literal: true
class Warehouse::Role < WarehouseRecord
  belongs_to :role_type
  belongs_to :event
  belongs_to :subject
end
