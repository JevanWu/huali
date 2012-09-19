ActiveAdmin.register ProductPart do

  controller do
    helper :product_parts
  end

  index do
    column "Image" do |product_part|
      image_tag product_part.asset.image.url(:thumb)
    end

    column "Chinese Name" do |product_part|
      link_to product_part.name_cn, admin_product_part_path(product_part)
    end

    column "English Name" do |product_part|
      link_to product_part.name_en, admin_product_part_path(product_part)
    end

    column "Belongs To" do |product_part|
      if product_part.product
        link_to product_part.product.name_cn, admin_product_path(product_part.product)
      end
    end

    default_actions
  end

  form :partial => "form"

  show do |product_part|

    attributes_table do
      row :name_cn
      row :name_en
      row :description
      row :belong_to do
        product = product_part.product
        link_to product.name_cn, admin_product_path(product) if product
      end

      row :pictures do
        image_tag product_part.asset.image.url(:medium).html_safe
      end

      row :thumbnails do
        image_tag product_part.asset.image.url(:thumb).html_safe
      end
    end
  end
end
