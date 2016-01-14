module DashboardsHelper

  STATUS_CHANGES = [ 'success', 'info', 'warning', 'danger' ]


  def render_plate(plate,stage)
    content_tag(:li,plate_options(plate,stage)) do
      entered_stage = plate.history.entered_stage(stage)
      entered_pipeline = plate.history.entered_stage(stage.first_stage)
      content_tag(:span,plate.friendly_name,class:'barcode') <<
      content_tag(:span,"#{plate.step_age}/#{plate.age}",class:'badge ')
    end
  end

  def status_colour(entered_stage,tat_target)
    days_in_stage = (Time.now - entered_stage) / 1.day
    return STATUS_CHANGES[3] if tat_target < days_in_stage
    return STATUS_CHANGES[2] if (tat_target - days_in_stage) < 1
    return STATUS_CHANGES[0] if days_in_stage < 1
    STATUS_CHANGES[1]
  end

  def popover_options(title,content)
    {
      title: title,
      data: {
        content: content,
        toggle: "popover",
        placement: "top",
        container: "body"
      }
    }
  end

  private

  def plate_options(plate,stage)
    style_colour = status_colour(plate.entered_stage,stage.turn_around_time)
    {
      class:"plate list-group-item list-group-item-#{style_colour} has-popover"
    }.merge(popover_options(plate.friendly_name,'Event history'))
  end

end
