ActiveAdmin.register AdminOperation do
  menu parent: '产品', if: proc { authorized? :read, AdminOperation }
  
  config.clear_action_items!

  index do
    column :administrator
    column :action
    column :product
    column "所修改字段" do |admin_operation|
      I18n.translate("activerecord.attributes.product.#{admin_operation.info}")
    end
    column "修改前" do |admin_operation|
      admin_operation.result
    end
    column :created_at
  end
end
