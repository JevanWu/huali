module MobileAPI
  class Pages < Grape::API

    resource :pages do
      desc "Return all static pages." 
      get do
        pages = Page.where(in_footer: true)
        res = Array.new
        pages.each do |page|
          page_info  = { id: page.id, title_zh: page.title_zh, title_en: page.title_en, content_zh: page.content_zh, content_en: page.content_en, permalink: page.permalink }
          res << product_info
        end
        res
      end
    end
  end
end
