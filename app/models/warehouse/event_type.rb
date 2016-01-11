# frozen_string_literal: true
class Warehouse::EventType < WarehouseRecord

  has_many :events

end
