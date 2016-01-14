module LinesHelper
  def event_header(product_line_event_type)
    content_tag(:th,{class:'stage has-popover'}.merge(popover_options(product_line_event_type.name,product_line_event_type.description))) do
      if product_line_event_type.last?
        t('.complete')
      else
        content_tag(:span,product_line_event_type.name,class:'event-name col-sm-9 col-xs-11') <<
        content_tag(:span,"➣➣➣",class:'progress-marker col-sm-1 hidden-xs') <<
        content_tag(:div,content_tag(:span, product_line_event_type.turn_around_time, class:"badge"),class:'col-xs-1') <<
        content_tag(:span,"➣➣➣",class:'progress-marker col-sm-1 hidden-xs')
      end
    end
  end
end
