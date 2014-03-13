module CustomCapybaraHelper
  def prepare_home_page
    stub(Product).find.with_any_args do |*args|
      if args.length > 1
        $cached_product ||= create(:product)

        products = []
        args.length.times do
          products << $cached_product
        end

        products
      else
        Product.send(:__rr__original_find, args.first)
      end
    end
  end

  def close_previous_window
    within_window(page.driver.browser.window_handles.first) do
      page.driver.browser.close
    end
  end

  def accept_confirm
    page.driver.browser.switch_to.alert.accept
  end

  def set_window_size(width, height)
    window = Capybara.current_session.driver.browser.manage.window
    window.resize_to(width, height)
  end
end
