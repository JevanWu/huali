class ProductObserver < ActiveRecord::Observer
  def after_save(product)
    Rails.cache.delete('menu_list')
  end

  def after_update(product)
    product.changed_attributes.delete("updated_at")
    product.changed_attributes.delete("administrator_id")
    admin = product.administrator
    product.changed_attributes.each do |attribute|
      AdminOperation.create(administrator: admin, action: "modify", product: product, info: attribute[0], result: attribute[1])
    end
  end
end
