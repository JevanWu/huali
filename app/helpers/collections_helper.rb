module CollectionsHelper
  def col_title_img(col)
    case col.slug
    when "preserved"
      'title-yongsheng.png'
    when "accessories-and-others"
      'title-dongxi.png'
    when "pure-color"
      'title-chuncui.png'
    when "designed-and-arranged"
      'title-nihong.png'
    when "surprise-me"
      'title-surprise.png'
    else
      'title-none.png'
    end
  end
end
