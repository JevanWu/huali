module ProductsHelper
  def link_to_add_assets(name, f, association)
    new_asset = Asset.new
    id = new_asset.object_id
    fields = f.fields_for(association, new_asset, child_index: id) do |builder|
      render('asset_fields', f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub('\n', '')})
  end

  def product_buy_link(product, options)
    link, sold_out_text = nil, nil

    if product.limited_promotion_today
      if product.limited_promotion_today.ended?
        sold_out_text = t('views.product.end_promo')
      elsif product.limited_promotion_today.started?
        link = link_to(t('views.product.start_promo'), current_order_path, options)
      else
        link = promo_pending_tag(product.limited_promotion_today, options)
      end
    else
      if product.count_on_hand > 0
        link = link_to(t('views.product.flower_basket'), current_order_path, options)
      else
        sold_out_text = t('views.product.soldout')
      end
    end

    render 'products/product_buy_link', link: link, sold_out_text: sold_out_text
  end

private

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
