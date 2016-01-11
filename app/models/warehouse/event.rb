# frozen_string_literal: true
class Warehouse::Event < WarehouseRecord

  belongs_to :event_type
  has_many :roles
  has_many :subjects, through: :roles
  has_many :metadata

end
