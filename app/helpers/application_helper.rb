module ApplicationHelper
  def markdown(text)
    if text
      Kramdown::Document.new(text).to_html.html_safe
    else
      ''
    end
  end
end
