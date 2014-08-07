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
    end

    resource :collections do

      desc "Return all collections of products"
      get do
        top_collections = Collection.available.where(parent_id: nil)
        error!('no available collection exists for now!', 500) if top_collections.nil?
        res = Array.new
        top_collections.each do |collection|
          collection_info = { id: collection.id, name_zh: collection.name_zh, name_en: collection.name_en, description: collection.description, priority: collection.priority, children_collections: children_collections(collection) } 
          res << collection_info
        end
        res
      end
    end
  end
end
