# encoding: utf-8
ActiveAdmin.register Coupon do
  menu parent: '设置', if: proc { authorized? :read, Coupon }

  batch_action :destroy, false

  controller do
    private

    def permitted_params
      params.permit(coupon: [:adjustment, :expires_at, :available_count, :note, :price_condition, :all_use_number, :prefix, :code_count, { product_ids: [] }])
    end

    def render_excel(coupon_codes, filename)
      columns = ["优惠码", "已使用次数", "剩余次数"]
      row_data = coupon_codes.map { |o| [o.code + " ", o.used_count, o.available_count] }

      xlsx = XlsxBuilder.new(columns, row_data).serialize

      send_data xlsx, :filename => "#{filename}", :type => Mime::Type.lookup_by_extension(:xlsx)
    end
  end

  filter :note
  filter :expires_at
  filter :adjustment
  filter :expired
  filter :price_condition

  member_action :download do
    coupon = Coupon.find_by_id(params[:id])

    xlsx_filename = "优惠码-#{coupon.note}(#{coupon.adjustment}).xlsx"

    render_excel(coupon.coupon_codes, xlsx_filename)
  end

  member_action :orders do
    coupon = Coupon.find_by_id(params[:id])

    @grouped_orders = coupon.orders.where("state not IN (?)", ["generated", "void", "wait_refund", "refunded"]).
      group_by { |o| o.created_at.to_date.month }
  end

  index do
    selectable_column
    column :adjustment
    column :expired
    column :note
    column :expires_at
    column :price_condition

    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :adjustment
      row :price_condition
      row :orders do
        coupon.orders.map do |order|
          link_to(order.identifier, admin_order_path(order))
        end.join(' ').html_safe
      end

      row :orders do
        link_to("订单详情", orders_admin_coupon_path(coupon), target: "_blank")
      end

      row :note
      row :expired
      row :expires_at

      row :code_count do
        coupon.coupon_codes.count
      end

      row :products do
        coupon.products.map do |product|
          link_to(product.name, admin_product_path(product))
        end.join(' ').html_safe
      end

      row "下载优惠码" do
        link_to "下载", download_admin_coupon_path(coupon)
      end

      row "优惠码" do
        code_string = "| 优惠码 | 使用次数 | 剩余次数 |<br />"
        code_string <<
          (coupon.coupon_codes.map do |coupon_code|
            "| #{coupon_code} | #{coupon_code.used_count} | #{coupon_code.available_count} |"
          end.join("<br />"))
        code_string.html_safe
      end
    end
  end
end
