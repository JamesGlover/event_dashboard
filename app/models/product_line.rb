# frozen_string_literal: true
class ProductLine < ActiveRecord::Base

  belongs_to :dashboard, required: true, inverse_of: :product_lines
  belongs_to :subject_type, required: true, class_name: 'Warehouse::SubjectType'
  belongs_to :role_type, required: true, class_name: 'Warehouse::RoleType'

  has_many :product_line_event_types, -> { order(:order) }, inverse_of: :product_line, dependent: :destroy

  validates_presence_of :name
  validates :product_line_event_types, length: { minimum: 2 }

  def report
    # If we're not valid, don't try and render a report, you'll only hurt yourself
    return [] unless valid?
    event_type_subjects = Hash.new {|h,i| h[i] = Array.new }

    relevant_events = product_line_event_types.pluck(:event_type_id)
    filters = {}

    subject_and_events.find_each do |subject|
      most_recent_tracked_event = subject.history.latest_in(relevant_events,filters)
      event_type_subjects[most_recent_tracked_event.event_type] << subject
    end

    product_line_event_types.map {|plet| [plet,event_type_subjects[plet.event_type]]}
  end

  def order_type; name; end

  def initial_event_type
    product_line_event_types.first.event_type
  end

  def final_event_type
    product_line_event_types.last.event_type
  end

  def subject_and_events
    Warehouse::Subject.
      of_type(subject_type_id).
      with_roles(role_type).
      with_event_type(initial_event_type).
      without_event_type(final_event_type).
      with_order_type(order_type).
      with_preloads
  end

  def serialize
    as_json(
      root: true,
      only: [:name],
      methods: [ :role_type_key, :subject_type_key ],
      include: {
        product_line_event_types: {
          only: :turn_around_time,
          methods: :key
        }
      }
    )
  end

  def role_type_key
    role_type.key
  end

  def subject_type_key
    subject_type.key
  end

end
