# encoding: utf-8
ActiveAdmin.register ShipMethod do
  menu parent: '设置', if: proc { can? :read, ShipMethod }

  controller do
    include ActiveAdminCanCan
    authorize_resource
  end

  index do
    selectable_column

    column :name, :sortable => :name
    column :method, :sortable => :method do |ship_method|
      t(ship_method.method)
    end
    column :service_phone

    default_actions
  end

  show do
    attributes_table do
      row :name
      row :method do |shipmethod|
        t(shipmethod.method)
      end
      row :service_phone
      row :website
      row :kuaidi_com_code
    end
  end

end
