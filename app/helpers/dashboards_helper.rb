module DashboardsHelper

  STATUS_CHANGES = [ 'success', 'info', 'warning', 'danger' ]

  Plate = Struct.new(:human_barcode,:age,:step_age,:entered_stage)

  def mock_plate
    age = rand(3)
    entered_stage = age.days.ago
    Plate.new("DN#{rand(9999999)}",rand(9),age,entered_stage)
  end

  def render_plate(plate=mock_plate)
    content_tag(:li,plate_options(plate)) do
      content_tag(:span,plate.human_barcode,class:'barcode') <<
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

  private

  def plate_options(plate)
    {
      class:"plate list-group-item list-group-item-#{status_colour(plate.entered_stage,1)} has-popover",
      title: plate.human_barcode,
      data: {
        content: "Event history",
        toggle: "popover",
        placement: "top",
        container: "body"
      }
    }
  end

end
