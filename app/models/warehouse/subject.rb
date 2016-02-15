# frozen_string_literal: true
require './lib/model_helpers/table_helpers'

class Warehouse::Subject < WarehouseRecord

  # Add some helper methods to make performing more complicated arel tidier
  extend ModelHelpers::TableHelpers

  belongs_to :subject_type
  has_many :roles, inverse_of: :subject
  has_many :events, ->() { order(:occured_at) }, through: :roles, inverse_of: :subjects

  scope :of_type, ->(type) { where(subject_type_id: type) }

  scope :with_roles, ->(role_type) {
    # Note: If we use an includes here, rails will use the roles loaded here when eager loading events
    # This causes issues as we are effectively squishing out all relevant events
    role_join = subjects_table.outer_join(roles_table).on(
      roles_table[:subject_id].eq(subjects_table[:id]).and(roles_table[:role_type_id].eq(role_type.id))
    )
    joins(role_join.join_sources)
  }

  scope :with_preloads, -> { preload(roles: [{event: [:event_type]}, :role_type, :event_type, :order_type_data ]) }

  # TODO: Make it more like this. Current issue are rails getting too smart for its own good wrt. eager loading
  # scope :with_roles, ->(role_type) {
  #   includes(:roles).where(roles:{role_type_id:[nil,role_type.id].uniq})
  # }

  scope :using_events, -> {
    joins(roles_table.outer_join(events_table).on(events_table[:id].eq(roles_table[:event_id])).join_sources)
  }

  scope :aggregate_events, -> {
    using_events.
    group('subjects.id')
  }

  scope :with_event_type, ->(event_type) {
    aggregate_events.having(['BIT_OR(events.event_type_id = ?)', event_type.id])
  }

  scope :without_event_type, ->(event_type) {
    aggregate_events.having(['NOT BIT_OR(events.event_type_id = ?)', event_type.id])
  }

  scope :with_order_type, ->(order_type_value) {
    metadata_table = Warehouse::Metadatum.arel_table
    joins(events_table.join(metadata_table).on(metadata_table[:event_id].eq(events_table[:id])).join_sources).
    where(metadata_table[:key].eq('order_type').and(metadata_table[:value].eq(order_type_value)))
  }

  def history
    PlateHistory.new(roles.sort_by(&:occured_at).reverse)
  end

end
