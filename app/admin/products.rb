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

  form do |f|
    f.inputs "Main Info" do
      f.input :name_cn, :label => "Chinese Name", :required => true
      f.input :name_en, :label => "English Name", :required => true
      f.input :description, :hint => "Use Markdown to write the content"
    end
    f.inputs "SKU Info" do
      f.input :count_on_hand, :label => "Count", :required => true
      f.input :price
      f.input :cost_price
      f.input :height
      f.input :width
      f.input :depth
      f.input :available_on, :as => :date_select
      f.input :deleted_at, :as => :date_select
    end
    f.inputs "SEO" do
      f.input :meta_keywords
      f.input :meta_description
    end
    f.buttons
  end

end
