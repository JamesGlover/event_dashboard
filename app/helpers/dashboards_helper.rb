module DashboardsHelper

  STATUS_CHANGES = [ 'success', 'info', 'warning', 'danger']

  def render_plate(plate,stage)
    content_tag(:li,plate_options(plate,stage)) do
      step_age = plate.history.days_in(stage)
      plate_age = plate.history.days_in(stage.first_stage)
      content_tag(:span,plate.friendly_name,class:'barcode') <<
      content_tag(:span,"#{step_age ? step_age.floor : '?'}/#{plate_age ? plate_age.floor : '?'}",class:'badge ')
    end
  end

  def status_colour(entered_stage,tat_target)
    return STATUS_CHANGES[1] if tat_target.nil? || entered_stage.nil?
    return STATUS_CHANGES[3] if tat_target < entered_stage
    return STATUS_CHANGES[2] if (tat_target - entered_stage) < 1
    return STATUS_CHANGES[0] if entered_stage < 1
    STATUS_CHANGES[1]
  end

  def popover_options(title,content)
    {
      title: title,
      data: {
        content: content,
        toggle: "popover",
        placement: "top",
        container: "body",
        html: true
      }
    }
  end

  private

  def plate_options(plate,stage)
    style_colour = status_colour(plate.history.days_in(stage),stage.turn_around_time)
    {
      class:"plate list-group-item list-group-item-#{style_colour} has-popover"
    }.merge(popover_options(plate.friendly_name,plate_history(plate,stage)))
  end

  def plate_history(plate,stage)
    content_tag(:ld,plate.history.matching(stage.filters).map do |event|
      content_tag(:dd,event.event_type.key.humanize) <<
      content_tag(:dt,event.occured_at)
    end.uniq.flatten.join(''))
  end

end
