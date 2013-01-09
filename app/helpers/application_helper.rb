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
end
