# frozen_string_literal: true
class Warehouse::Subject < WarehouseRecord
  belongs_to :subject_type
  has_many :roles
  has_many :events, through: :roles

  scope :of_type, ->(type) { joins(:subject_type).where(subject_types:{key:type}) }

  # SELECT subjects.friendly_name, MIN(library_start.occured_at) AS started, MAX(library_complete.occured_at) FROM subjects
  # LEFT JOIN subject_types ON subject_types.id = subjects.subject_type_id
  # LEFT OUTER JOIN roles ON roles.subject_id = subjects.id
  # LEFT OUTER JOIN events AS library_start ON library_start.event_type_id = 1 AND roles.event_id = library_start.id
  # LEFT OUTER JOIN events AS library_complete ON library_complete.event_type_id = 2 AND roles.event_id = library_complete.id
  # WHERE subject_types.key = 'submission'
  # GROUP BY subjects.id;
# 'events AS start_event ON start_event.event_type_id = ? AND roles.event_id = start_event.id'
  scope :with_role_in, ->(role_key,event_type) {
    start_event = Arel::Table.new(:events).alias('start_event')
    roles_table = Arel::Table.new(:roles)
    subjects_table = Arel::Table.new(:subjects)

    role_join = subjects_table.outer_join(roles_table).on(roles_table[:subject_id].eq(subjects_table[:id]))

    # We need to do an outer join, so build it up in arel
    # first. Just using outer_join iteslf in the scope converts
    # everything to an Arel::SelectManager, rather than a rails relation
    oj = roles_table.outer_join(start_event).on(
      start_event[:event_type_id].eq(event_type.id).and(
        start_event[:id].eq(roles_table[:event_id])))

    joins(role_join.join_sources).
    joins(oj.join_sources).
    group('subjects.id').
    having(start_event[:occured_at].minimum.gt(0))

  }

  scope :without_role_in, ->(role_key,event_type) {
    end_event = Arel::Table.new(:events).alias('end_event')
    roles_table = Arel::Table.new(:roles)
    subjects_table = Arel::Table.new(:subjects)

    role_join = subjects_table.outer_join(roles_table).on(roles_table[:subject_id].eq(subjects_table[:id]))

    # We need to do an outer join, so build it up in arel
    # first. Just using outer_join iteslf in the scope converts
    # everything to an Arel::SelectManager, rather than a rails relation
    oj = roles_table.outer_join(end_event).on(
      end_event[:event_type_id].eq(event_type.id).and(
        end_event[:id].eq(roles_table[:event_id])))

    joins(role_join.join_sources).
    joins(oj.join_sources).
    group('subjects.id').
    having('MAX(end_event.occured_at) IS NULL')
    # end_event[:occured_at].maximum.eq(nil)
  }

end
