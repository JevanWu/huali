# encoding: utf-8
ActiveAdmin.register ShipMethod do
  menu parent: '设置', if: proc { authorized? :read, ShipMethod }

  index do
    selectable_column

    column :name, sortable: :name
    column :method, sortable: :method do |ship_method|
      t('views.admin.ship_method.' + ship_method.method)
    end
    column :service_phone
    column :kuaidi_com_code

    default_actions
  end

  form partial: "form"

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
