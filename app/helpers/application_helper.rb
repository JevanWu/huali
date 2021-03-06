module ApplicationHelper
  def markdown(text)
    if text
      Kramdown::Document.new(text).to_html.html_safe
    else
      ''
    end
  end

  def icon(name)
    content_tag('i', '', class: "icon-#{name}")
  end

  def current_if_action(*actions)
    actions.include?(action_name) ? 'cur' : ''
  end

  def current_if_controller(*controllers)
    controllers.include?(controller_name) ? 'cur' : ''
  end

  def controller_and_action?(the_controller, the_action)
    controller_name == the_controller && the_action == action_name
  end

  def display_flower_picker?
    [/^\/collections/, /^\/products(?!\/trait)/, /^\/$/].any? do |reg|
      reg =~ request.path
    end
  end
end
