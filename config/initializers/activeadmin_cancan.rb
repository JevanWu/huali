module ActiveAdmin
  # lib/active_admin/resource_controller/collection.rb
  class ResourceController
    module Collection
      module BaseCollection
        def scoped_collection
          end_of_association_chain.accessible_by(current_ability)
        end
      end
    end
  end
end
