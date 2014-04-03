class CollectionObserver < ActiveRecord::Observer
  def after_save(collection)
    Rails.cache.delete('menu_list')
  end
end
