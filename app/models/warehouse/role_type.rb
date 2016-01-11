# frozen_string_literal: true
class Warehouse::RoleType < WarehouseRecord
  has_many :roles
end
