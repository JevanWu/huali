module ProductsHelper
  def link_to_add_assets(name, f, association)
    new_asset = Asset.new
    id = new_asset.object_id
    fields = f.fields_for(association, new_asset, child_index: id) do |builder|
      render('asset_fields', f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub('\n', '')})
  end

  def filter_path(collection, flower_type_param, color_param, price_param)
    if collection.present?
      collection_products_path(collection, flower_type: flower_type_param, color: color_param, price_span: price_param)
    else
      products_path(flower_type: flower_type_param, color: color_param, price_span: price_param)
    end
  end

=begin
  def product_buy_link(product, options, is_mobile = false)
    link, sold_out_text = nil, nil

    if product.limited_promotion_today
      if product.limited_promotion_today.ended?
        sold_out_text = t('views.product.end_promo')
      elsif product.limited_promotion_today.started?
        link = buy_button_or_link(t('views.product.start_promo'), current_order_path, options, is_mobile)
      else
        link = promo_pending_tag(product.limited_promotion_today, options)
      end
    else
      if product.count_on_hand > 0
        link = buy_button_or_link(t('views.product.flower_basket'), current_order_path, options, is_mobile)
      end
    end

    render 'products/product_buy_link', link: link, sold_out_text: sold_out_text
  end
=end

private

  def buy_button_or_link(text, path, options, is_mobile)
    if is_mobile
      content_tag :button, options.merge(href: path) do
        text
      end
    else
      link_to(text, path, options)
    end
  end

  def promo_pending_tag(limited_promotion, options)
    content_tag :p, options do
      if !limited_promotion.close_to_start_time?
        t('views.product.start_promo_at', time: limited_promotion.start_at.strftime("%H:%M"))
      elsif limited_promotion.close_to_start_time? && !limited_promotion.started?
        t('views.product.close_promo')
      end
    end
  end

end
