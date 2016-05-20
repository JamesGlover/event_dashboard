# frozen_string_literal: true
class Warehouse::RoleType < WarehouseRecord
  has_many :roles, inverse_of: :role_type
end
