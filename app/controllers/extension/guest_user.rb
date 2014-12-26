module Extension
  module GuestUser

    # if user is logged in, return current_user, else return guest_user
    def current_or_guest_user
      if current_user
        migrate_from_guest
        current_user
      else
        guest_user
      end
    end

    def guest_user
      session[:guest_user_id] ||= User.build_guest.id
      User.find_by_id session[:guest_user_id]
    end

    private
    def migrate_from_guest
      if session[:guest_user_id]
        hand_off_guest
      end
    end

    def destroy_guest
      guest_user.destroy
      session[:guest_user_id] = nil
    end

    # hand off resources from guest_user to current_user.
    def hand_off_guest
      cart_user = Cart.find_by user_id: current_user
      cart_guest = Cart.find_by user_id: guest_user.id

      return if cart_guest.nil?
      destroy_guest and return if cart_guest.cart_line_items.empty?

      if cart_user
        cart_guest.cart_line_items.find_each do |i|
          item = cart_user.cart_line_items.find_by(product_id: i.product_id)
          if item
            item.quantity += i.quantity
            item.save
          else
            cart_user.cart_line_items << i
          end
        end
        cart_user.save
        destroy_guest
      else
        cart_guest.user_id = current_user.id
        cart_guest.save
        session[:guest_user_id] = nil
      end

      #guest_orders = guest_user.orders.all
      #guest_orders.each do |order|
        #order.user_id = current_user.id
        #order.save
      #end
    end
  end
end
