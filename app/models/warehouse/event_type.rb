# frozen_string_literal: true
class Warehouse::EventType < WarehouseRecord

  has_many :events, inverse_of: :event_type

end
