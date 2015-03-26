class ProductObserver < ActiveRecord::Observer
  def after_save(product)
    Rails.cache.delete('menu_list')
  end

  def after_update(product)
    changed = product.changed_attributes.except(:updated_at, :administrator_id, :tag_list, :trait_list, :color_list)
    admin = product.administrator
    changed.each do |attribute|
      AdminOperation.create(administrator: admin, action: "modify", product: product, info: attribute[0], result: attribute[1])
    end
  end
end
