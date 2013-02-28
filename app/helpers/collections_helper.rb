module CollectionsHelper
  def col_title_img(col)
    case col.id
    when 8
      'title-yongsheng.png'
    when 4
      'title-dongxi.png'
    when 10
      'title-chuncui.png'
    when 9
      'title-nihong.png'
    when 11
      'title-surprise.png'
    end
  end
end
