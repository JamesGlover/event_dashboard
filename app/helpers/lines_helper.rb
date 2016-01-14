module LinesHelper
  def event_header(product_line_event_type)
    content_tag(:th,product_line_event_type.name,{class:'stage has-popover'}.merge(popover_options(product_line_event_type.name,product_line_event_type.description)))
  end
end
