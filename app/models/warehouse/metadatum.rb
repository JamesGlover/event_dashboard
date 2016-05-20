# frozen_string_literal: true
class Warehouse::Metadatum < WarehouseRecord
  belongs_to :event, inverse_of: :metadata

  scope :with_key, ->(key) { where(key:key) }
end
