class ProductObserver < ActiveRecord::Observer
  def after_save(product)
    Rails.cache.delete('menu_list')
  end
end
