ActiveAdmin.register FeaturedProduct do
  menu parent: '设置', if: proc { authorized? :read, FeaturedProduct}
  
  sortable tree: false,
           protect_root: false,
           sorting_attribute: :priority

  controller do
    def permitted_params
      params.permit(featured_product: [:cover, :description, :available, :priority, :product_id])
    end
  end

  form partial: "form"

  index as: :sortable do
    label :cover do |featured_product|
      image_tag featured_product.cover.url
    end
    actions
  end
  
end
