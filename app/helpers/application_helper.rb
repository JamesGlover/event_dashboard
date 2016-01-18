module ApplicationHelper

  def application_title
    t(:title,scope: :application)
  end

  def page_title
    t(:title,scope: [:controllers,controller_name], default:'')
  end

  def action_title
    custom_action = params[:id].to_s.humanize
    t(:title,scope: [:controllers,controller_name,:actions,action_name],default: custom_action)
  end

  def title_banner(subtitle=action_title)
    content_tag(:div, :class=>"page-header") do
      content_tag(:h1) do
        core = escape_once(page_title.upcase).html_safe
        core << " " << content_tag(:small,subtitle)
        core
      end
    end
  end

  def bs_well(&block)
    content_tag(:div, class:'well', &block)
  end

  def jumbotron(&block)
    content_tag(:div, class:'jumbotron', &block)
  end

  def panel(type=:default,options={},&block)
    bs_custom_panel(type,:div,{:class=>"panel-body"},options,&block)
  end

  def list_panel(type=:default,options={},&block)
    bs_custom_panel(type,:ul,{:class=>"list-group"},options,&block)
  end

  def link_panel(type=:default,options={},&block)
    bs_custom_panel(type,:div,{:class=>"list-group"},options,&block)
  end

  def bs_custom_panel(type,body_type,body_options,options,&block)
    title = options.delete(:title)
    options[:class] ||= String.new
    options[:class] << " panel panel-#{type}"
    content_tag(:div,options) do
      out = String.new.html_safe
      out << content_tag(:div,:class=>"panel-heading") do
        content_tag(:h3,title,:class=>"panel-title")
      end unless title.nil?
      out << content_tag(body_type,body_options,&block)
    end
  end

  def bs_alert(style,message)
    content_tag(:div, class:"alert alert-#{style}", role:"alert") do
      content_tag(:strong,t(style,scope:['general','alert','title'])) << " " <<
      content_tag(:span,message,class:"alert-message")
    end
  end

  def render_flashes
    flash.each do |status,message|
      concat bs_alert(status,message)
    end
    nil
  end
end
