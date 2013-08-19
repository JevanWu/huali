module CustomCapybaraHelper
  def close_previous_window
    within_window(page.driver.browser.window_handles.first) do
      page.driver.browser.close
    end
  end

  def accept_confirm
    page.driver.browser.switch_to.alert.accept
  end
end
