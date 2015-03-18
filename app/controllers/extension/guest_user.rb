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
      user_cart = Cart.find_by user_id: current_user
      guest_cart = Cart.find_by user_id: guest_user.id

      return if guest_cart.nil?
      destroy_guest and return if guest_cart.cart_line_items.empty?

      user_cart.destroy if user_cart
      guest_cart.user_id = current_user.id
      guest_cart.save
      session[:guest_user_id] = nil
    end
  end
end
