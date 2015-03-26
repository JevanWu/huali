class ProductObserver < ActiveRecord::Observer
  def after_save(product)
    Rails.cache.delete('menu_list')
  end

  def after_update(product)
    %w(updated_at, administrator_id, tag_list, trait_list, color_list).each do |attribute|
      product.changed_attributes.delete(attribute)
    end
    admin = product.administrator
    product.changed_attributes.each do |attribute|
      AdminOperation.create(administrator: admin, action: "modify", product: product, info: attribute[0], result: attribute[1])
    end
  end
end
