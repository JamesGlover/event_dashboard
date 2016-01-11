# frozen_string_literal: true
class ProductLine < ActiveRecord::Base

  belongs_to :dashboard, required: true, inverse_of: :product_lines
  has_many :product_line_event_types, -> { order(:order) }, inverse_of: :product_line, dependent: :destroy

  validates_presence_of :name

end
