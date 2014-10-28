module MobileAPI
  class Collections < Grape::API

    helpers do
      def children_collections(collection)
        children_info = Array.new
        return nil if collection.children.nil?
        collection.children.each do |child|
          child_info = { id: child.id, name_zh: child.name_zh, name_en: child.name_en, description: child.description, priority: child.priority, children_collections: children_collections(child) }
          children_info << child_info
        end
        children_info
      end

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
          medium: product.rectangle_image(:medium)
          small: product.rectangle_image(:small)
          thumb: product.rectangle_image(:thumb)
        }
      end
    end

    resource :collections do

      desc "Return all collections of products"
      get do
        top_collections = Collection.available.where(parent_id: nil)
        error!('no available collection exists for now!', 404) if !top_collections.present?
        res = Array.new
        top_collections.each do |collection|
          collection_info = { id: collection.id, name_zh: collection.name_zh, name_en: collection.name_en, description: collection.description, priority: collection.priority, children_collections: children_collections(collection) } 
          res << collection_info
        end
        res
      end

      desc "Return all products of a collection"
      get ":id/products" do
        collection = Collection.find(params[:id])
        error!('Cannot find the collection', 404) if !collection.present?
        products = collection.products
        error!('The collection has no products!', 404) if !products.present?
        res = []
        products.each do |product|
          product_info  = { 
            id: product.id, 
            name_zh: product.name_zh, 
            name_en: product.name_en, 
            description: product.description, 
            count_on_hand: product.count_on_hand, 
            price: product.price, 
            height: product.height, 
            width: product.width, 
            depth: product.depth, 
            priority: product.priority, 
            product_type: product.product_type, 
            images: product_images(product) 
            rectangle_images: rectangle_images(product)
          }
          res << product_info
        end
        res
      end
    end
  end
end
