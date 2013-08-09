module CustomCapybaraHelper
  def close_previous_window
    within_window(page.driver.browser.window_handles.first) do
      page.driver.browser.close
    end
  end
end
