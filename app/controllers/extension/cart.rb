module Extension
  module Cart
    def load_cart
      line_item_hash, coupon_code = load_cart_cookie

      line_items = line_item_hash.map do |k, v|
        LineItem.new(product_id: k, quantity: v)
      end

      if line_items.present?
        @cart = ::Cart.new(line_items, coupon_code)
        @products = line_items.map(&:product)
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
      @products ||= []

      recommendations = @products.inject([]) { |s, p| s + p.recommendations }
      suggestions = @products.inject([]) { |s, p| s + p.suggestions }

      @related_products = (recommendations + suggestions).take(7)
    end
  end
end

