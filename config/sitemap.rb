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

SitemapGenerator::Sitemap.default_host = "http://hua.li"

SitemapGenerator::Sitemap.create do
  add '/faq', changefreq: 'weekly', priority: 0.33
  add '/about', changefreq: 'monthly', priority: 0.33
  add '/help-center', changefreq: 'weekly', priority: 0.33
  add '/copyright', changefreq: 'yearly', priority: 0.33
  add '/brands', changefreq: 'monthly', priority: 0.33
  add '/celebrities', changefreq: 'monthly', priority: 0.33
  add '/medias', changefreq: 'monthly',  priority: 0.33
  add '/blog', changefreq: 'daily', priority: 0.5
  add '/muqinjie', changefreq: 'weekly', priority: 0.6
  add '/qixijie', changefreq: 'weekly', priority: 0.9
  add '/weibo_stories', changefreq: 'monthly', priority: 0.5

  I18n.locale = :'zh-CN'

  promotion_collections = %w(haagen-dazs uber philips aston-martin acqua-di-parma givenchy davidoff chloe sally-hansen marc-jacobs swarovski-elements ermenegildo-zegna helena-rubinstein).map { |slug| Collection.friendly.find(slug) }
  promotion_collections.each do |collection|
    add collection_products_path(collection), lastmod: collection.updated_at, priority: 0.8
  end

  promotion_products = ['polka-dot--ab8e8fa1-0538-40a0-8955-8f9644ab4cf5',
                        'the-girl-appreciation',
                        'mother',
                        'charming-dna',
                        'the-key-of-the-forest'].map { |slug| Product.friendly.find(slug) }
  promotion_products.each do |product|
    product_images = product.assets.map do |asset|
      { loc: asset.image.url(:medium), title: product.name }
    end

    add(product_path(product), lastmod: product.updated_at, images: product_images, priority: 0.65)
  end

  Product.find_each do |product|
    next if promotion_products.include?(product)

    product_images = product.assets.map do |asset|
      { loc: asset.image.url(:medium), title: product.name }
    end

    add(product_path(product), lastmod: product.updated_at, images: product_images, priority: 0.5)
  end

  Collection.find_each do |collection|
    next if promotion_collections.include?(collection)

    collection_images = []
    collection.products.each do |product|
      product.assets.map do |asset|
        collection_images << { loc: asset.image.url(:medium), title: product.name }
      end
    end

    add(collection_products_path(collection), lastmod: collection.updated_at, images: collection_images, priority: 0.5)
  end

end
