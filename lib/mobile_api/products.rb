module MobileAPI
  class Products < Grape::API

    helpers do
      def product_images(product)
        full = []
        medium = []
        small = []
        thumb = []
        product.assets.each do |asset|
          full << asset.image.url
          medium << asset.image.url(:medium)
          small << asset.image.url(:small)
          thumb << asset.image.url(:thumb)
        end
        { full: full, medium: medium, small: small, thumb: thumb }
      end
    end

    resource :products do
      desc "Return all published products." 
      get do
        products = Product.where(published: true)
        res = Array.new
        products.each do |product|
          product_info  = { id: product.id, name_zh: product.name_zh, name_en: product.name_en, description: product.description, count_on_hand: product.count_on_hand, price: product.price, height: product.height, width: product.width, depth: product.depth, priority: product.priority, product_type: product.product_type, images: product_images(product) }
          res << product_info
        end
        res
      end

      desc "Return the required product"
      params do
        requires :id, type: Integer, desc: "Product id."
      end
      get ':id' do
        product = Product.find(params[:id])
        error!('There is no such product!', 400) if product.nil?
        res = { id: product.id, name_zh: product.name_zh, name_en: product.name_en, description: product.description, count_on_hand: product.count_on_hand, price: product.price, height: product.height, width: product.width, depth: product.depth, priority: product.priority, product_type: product.product_type, images: product_images(product) }
      end
    end
  end
end
