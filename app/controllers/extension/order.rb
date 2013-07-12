module Extension
  module Order
    def load_cart
      begin
        @cart = JSON.parse(cookies['cart']).select {|k, v| k =~ /^\d+$/}
      rescue
        @cart = {}
      end
    end

    def fetch_items
      @products = []
      @cart.keys.each do |key|
        if product = Product.find_by_id(key)
          product.quantity = @cart[key]
          @products.push product
        end
      end
    end

    def fetch_related_products
      recommendations = @products.inject([]) { |s, p| s + p.recommendations }
      suggestions = @products.inject([]) { |s, p| s + p.suggestions }

      @related_products = (recommendations + suggestions).take(7)
    end
  end
end
