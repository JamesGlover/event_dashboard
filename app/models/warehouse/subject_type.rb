# frozen_string_literal: true
class Warehouse::SubjectType < WarehouseRecord
  has_many :subjects, inverse_of: :subject_type
end
