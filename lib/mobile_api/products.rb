module MobileAPI
  class Products < Grape::API

    helpers do
      def product_images(product)
        res = []
        product.assets.each do |asset|
          asset_info = {
            image_file_name: asset.image_file_name,
            full: asset.image.url,
            medium: asset.image.url(:medium),
            small: asset.image.url(:small),
            thumb: asset.image.url(:thumb)
          }
          res << asset_info
        end
        res
      end

      def rectangle_images(product)
        {
          medium: product.rectangle_image(:medium),
          small: product.rectangle_image(:small),
          thumb: product.rectangle_image(:thumb)
        }
      end
    end

    resource :products do
      desc "Return all published products." 
      params do
        optional :per_page, type: Integer, desc: "The amount of products presented on each page"
        optional :page, type: Integer, desc: "The number of page queried"
      end
      get do
        if params[:per_page]&&params[:page]
          products = Product.where(published: true).limit(params[:per_page]).offset(params[:per_page]*(params[:page] - 1))
        else
          products = Product.where(published: true)
        end

        error!('There is no published products!', 404) if !products.present?
        res = Array.new
        products.each do |product|
          product_info  = { 
            id: product.id, 
            name_zh: product.name_zh, 
            name_en: product.name_en, 
            inspiration: product.inspiration,
            maintenance: product.maintenance,
            delivery: product.delivery,
            material: product.material,
            description: product.description, 
            count_on_hand: product.count_on_hand, 
            price: product.price, 
            height: product.height, 
            width: product.width, 
            depth: product.depth, 
            priority: product.priority, 
            product_type: product.product_type_text, 
            images: product_images(product) 
            rectangle_images: rectangle_images(product)
          }
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
        error!('There is no such product!', 404) if !product.present?
        res = { 
            id: product.id, 
            name_zh: product.name_zh, 
            name_en: product.name_en, 
            inspiration: product.inspiration,
            maintenance: product.maintenance,
            delivery: product.delivery,
            material: product.material,
            description: product.description, 
            count_on_hand: product.count_on_hand, 
            price: product.price, 
            height: product.height, 
            width: product.width, 
            depth: product.depth, 
            priority: product.priority, 
            product_type: product.product_type_text, 
            images: product_images(product) 
            rectangle_images: rectangle_images(product)
        }
      end
    end
  end
end
