# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.hua.li"

SitemapGenerator::Sitemap.create do
  add '/faq', :changefreq => 'weekly'
  add '/about', :changefreq => 'weekly'
  add '/help-center', :changefreq => 'weekly'
  add '/copyright', :changefreq => 'weekly'
  Product.unscoped.find_each do |product|
    
    product_images = []

    product.assets.each do |asset|
      product_image = {}
      product_image[:loc] = asset.image.url(:medium)
      product_image[:title] = product.name
      product_images << product_image
    end


    add(product_path(product), :lastmod => product.updated_at, :images => product_images)
  end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
