module BreadcrumbHelper
  def breadcrumb_generator(item)
    link = link_to "花里首页", root_path
    lies = content_tag(:li, link)
    if item.is_a? Product
      collections = item.collections.display_on_breadcrumb
      collections.each do |col|
        link = link_to "#{col.name_zh}", collection_products_path(col)
        lies += content_tag(:li, link)
      end
      lies += content_tag(:li, item.name_zh)
    elsif item.is_a? Collection
      lies += content_tag(:li, item.name_zh)
    end

    content_tag(:ol, lies, class: "breadcrumb")
  end
end
