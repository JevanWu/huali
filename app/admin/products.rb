ActiveAdmin.register Product do
  index do
    column "Chinese Name" do |product|
      link_to product.name_cn, admin_product_path(product)
    end

    column "English Name" do |product|
      link_to product.name_en, admin_product_path(product)
    end

    column "Count", :count_on_hand

    column :price, :sortable => :price do |product|
      div :class => "price" do
        number_to_currency product.price
      end
    end
  default_actions
  end

  form :partial => "form"
end
