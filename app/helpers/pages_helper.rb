module PagesHelper
  def path_to_promo_product
    promo_today = LimitedPromotion.start_today.first || LimitedPromotion.first
    product_path(promo_today.product)
  end
end
