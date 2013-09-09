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
end
