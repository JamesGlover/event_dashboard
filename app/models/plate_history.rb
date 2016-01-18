class PlateHistory

  attr_reader :roles

  def initialize(*roles)
    @roles = roles.flatten
  end

  def latest(event_type,filters={})
    roles.detect do |role|
      role.event_type == event_type && filter(role,filters)
    end&.event
  end

  def latest_in(relevant_events,filters={})
    matching(filters).reduce(nil) do |most_recent,event|
      if relevant_events.include?(event.event_type_id)
        most_recent.present? && most_recent > event ? most_recent : event
      else
        most_recent
      end
    end
  end

  def matching(filters)
    roles.reduce([]) do |matching,role|
      matching << role.event if filter(role,filters)
      matching
    end
  end

  def entered_stage(product_line_event_type)
    event_type = product_line_event_type.event_type
    filters = {
      :order_type => product_line_event_type.order_type,
      :role_type => product_line_event_type.role_type
    }
    latest(event_type,filters)&.occured_at||nil
  end

  def days_in(product_line_event_type)
    entered_stage = entered_stage(product_line_event_type)
    entered_stage && (Time.now - entered_stage) / 1.day
  end


  private

  def filter(role,filters)
    ( filters[:order_type].nil? || filters[:order_type] == role.order_type ) &&
    ( filters[:role_type].nil? || filters[:role_type] == role.role_type )
  end

end
