module Extension
  module CookieCart
    def load_cart
      return if controller_path.split('/').first == "admin" # Skip load cart in admin pages

      line_item_hash, coupon_code = load_cart_cookie

      line_items = line_item_hash.map do |k, v|
        product = Product.published.where(id: k).first

        LineItem.new(product_id: k, quantity: v, price: product.price) if product
      end.compact

      if line_items.present?
        @cart = ::Cart.new(line_items, coupon_code)
        @products_in_cart = line_items.map(&:product)

        if @cart.limited_promotion_today
          cookies[:in_limited_promotion] = true # set flag of buying promo product
        end
      end
    end

    def update_coupon_code(coupon_code)
      @cart.coupon_code = coupon_code
      if @cart.valid_coupon?
        cookies[:coupon_code] = coupon_code
      else
        cookies.delete :coupon_code
      end
    end

    def empty_cart
      cookies.delete :cart
      cookies.delete :coupon_code
    end

    def load_cart_cookie
      begin
        cart_cookie_hash = JSON.parse(cookies['cart'])
        line_item_hash = cart_cookie_hash.select {|k, v| k =~ /^\d+$/}

        coupon_code = cookies[:coupon_code]

        [line_item_hash, coupon_code]
      rescue
        [{}, nil]
      end
    end

    def fetch_related_products
      @products_in_cart ||= []
      @related_products = @products_in_cart.reduce([]) { |s, product| s + product.related_products(5) }.take(5)
    end
  end
end

