# encoding: utf-8
ActiveAdmin.register Product do
  menu parent: '产品', if: proc { authorized? :read, Product }

  [ :publish,
    :unpublish
 ].each do |action|
    batch_action I18n.t(action) do |selection|
      products = Product.find(selection)
      products.each { |product| product.send(action) }
      redirect_to :back, notice: products.count.to_s + t('views.admin.product.product_updated')
    end
  end
  batch_action :destroy, false

  scope :published, default: true
  scope :unpublished

  controller do
    helper :products
    before_action :authorize_seo_permission, only: [:create, :update]

    def scoped_collection
      Product.includes(:assets, :collections)
    end

    private

    def authorize_seo_permission
      current_admin_ability.authorize! :update_seo, Product if edit_seo?
    end

    def edit_seo?
      !!params[:product][:meta_title] ||
        !!params[:product][:meta_keywords] ||
        !!params[:product][:meta_description]
    end

    def full_product_fields
      [
        :published,
        :name_zh,
        :name_en,
        :priority,
        :tag_list,
        :trait_list,
        :inspiration,
        :material,
        :maintenance,
        :delivery,
        :product_type,
        :description,
        :count_on_hand,
        :price,
        :original_price,
        :sku_id,
        :width,
        :depth,
        :height,
        :meta_title,
        :meta_keywords,
        :meta_description,
        :default_date_rule_id,
        :default_region_rule_id,
        :rectangle_image,
        :discountable,
        :promo_tag,
        :flower_type,
        :print_id,
        :color_list,
        :assets_attributes => [ :id, :image, :_destroy ],
        :collection_ids => [],
        :recommendation_ids => [],
        :local_date_rule_attributes => [:start_date, :period_length, :included_dates, :excluded_dates, { excluded_weekdays: [] }, :_destroy],
        :local_region_rule_attributes => [:province_ids, :city_ids, :area_ids, :_destroy]
      ]
    end

    def permitted_params
      params.permit(product: full_product_fields)
    end
  end

  filter :published
  filter :name_zh
  filter :name_en
  filter :sku_id
  filter :price
  filter :original_price
  filter :tags
  filter :sold_total
  filter :meta_keywords
  filter :meta_title
  filter :meta_description


  collection_action :download, method: :get do
    filename = "/tmp/products-#{Time.current.to_i}.xlsx"
    record = Product.all

    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Product") do |sheet|
        sheet.add_row %w[ID 中文名 英文名 递送区域规则 递送时间规则]
        record.each do |product|
          array = []
          array << product.id
          array << product.name_zh
          array << product.name_en
          array << product.region_rule.name ? product.region_rule.name : "name empty"
          array << product.date_rule.name ? product.date_rule.name : "name empty"
          sheet.add_row array
        end
      end
      p.serialize(filename)
    end

    send_file filename, x_sendfile: true, type: Mime::Type.lookup_by_extension(:xlsx).to_s
  end

  index do
    div style: "text-align: right" do
      link_to('download', action: :download)
    end

    selectable_column
    column "ID" do |product|
      link_to product.id, product_path(product)
    end

    column :name_zh
    column :name_en

    column :image do |product|
      image_tag product.img(:thumb)
    end

    column :product_type do |product|
      product.product_type_text
    end

    column :count_on_hand

    column :collections do |product|
      product.collections.map do |collection|
        link_to collection.name, admin_collection_path(collection)
      end.join(', ').html_safe
    end

    column :priority

    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :name_zh
      row :name_en
      row :sku_id
      row :published
      row :promo_tag
      row :discountable
      row :product_type do
        product.product_type_text
      end
      row :flower_type do
        product.flower_type_text
      end
      row :priority

      row :tag_list
      row :trait_list
      row :color_list

      row :sold_total

      row :material do
        markdown(product.material)
      end

      row :inspiration do
        markdown(product.inspiration)
      end

      row :maintenance do
        markdown(product.maintenance)
      end

      row :delivery do
        markdown(product.delivery)
      end

      row :description do
        markdown(product.description)
      end

      row :collections do
        product.collections.map do |collection|
          link_to collection.name, admin_collection_path(collection)
        end.join(', ').html_safe
      end

      row :recommendations do
        product.recommendations.map do |product|
          link_to product.name, admin_product_path(product)
        end.join(', ').html_safe
      end

      row :image do
        product.assets.map do |asset|
          image_tag asset.image.url(:medium)
        end.join(' ').html_safe
      end

      row :thumbnail do
        product.assets.map do |asset|
          image_tag asset.image.url(:thumb)
        end.join(' ').html_safe
      end

      row :rectangle_image do
        image_tag product.rectangle_image.url(:medium)
      end

      row :count_on_hand

      row :original_price do
        number_to_currency product.original_price
      end

      row :price do
        number_to_currency product.price
      end

      row :height do
        number_to_human(product.height, units: :distance) if product.height
      end

      row :width do
        number_to_human(product.width, units: :distance) if product.width
      end

      row :depth do
        number_to_human(product.depth, units: :distance) if product.depth
      end

      row :print_id 

      row :created_at
      row :updated_at
    end
  end
end
