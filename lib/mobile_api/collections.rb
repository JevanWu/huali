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
      get :collection do
        top_collections = Collection.available.where(parent_id: nil)
        error!('no available collection exists for now!', 500) if collections.nil?
        res = Array.new
        collections.each do |collection|
          collection_info = { id: child.id, name_zh: child.name_zh, name_en: child.name_en, description: child.description, priority: child.priority, children_collections: children_collections(child) } 
          res << collection_info
        end
        res
      end
    end
  end
end
