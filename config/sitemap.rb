# Set the host name for URL creation
# Put links creation logic here.
#
# The root path '/' and sitemap index file are added automatically for you.
# Links are added to the Sitemap in the order they are specified.
#
# Usage: add(path, options={})
#        (default options are used if you don't specify)
#
# Defaults: priority: 0.5, changefreq: 'weekly',
#           lastmod: Time.now, host: default_host
#
# Examples:
#
# Add '/articles'
#
#   add articles_path, priority: 0.7, changefreq: 'daily'
#
# Add all articles:
#
#   Article.find_each do |article|
#     add article_path(article), lastmod: article.updated_at
#   end

SitemapGenerator::Sitemap.default_host = "http://www.hua.li"

SitemapGenerator::Sitemap.create do
  add '/faq', changefreq: 'weekly', priority: 0.33
  add '/about', changefreq: 'monthly', priority: 0.33
  add '/help-center', changefreq: 'weekly', priority: 0.33
  add '/copyright', changefreq: 'yearly', priority: 0.33
  add '/brands', changefreq: 'monthly', priority: 0.33
  add '/celebrities', changefreq: 'monthly', priority: 0.33
  add '/medias', changefreq: 'monthly',  priority: 0.33
  add '/blog', changefreq: 'daily', priority: 0.5 
  add '/muqinjie', changefreq: 'weekly', priority: 0.95
  add '/weibo_stories', changefreq: 'monthly', priority: 0.5

  I18n.locale = :'zh-CN'

  Product.find_each do |product|

    product_images = product.assets.map do |asset|
      { loc: asset.image.url(:medium), title: product.name }
    end

    add(product_path(product), lastmod: product.updated_at, images: product_images, priority: 0.5)
  end

  Collection.find_each do |collection|
    collection_images = []
    collection.products.each do |product|
      product.assets.map do |asset|
        collection_images << { loc: asset.image.url(:medium), title: product.name }
      end
    end

    add(collection_products_path(collection), lastmod: collection.updated_at, images: collection_images, priority: 0.5)
  end
end
