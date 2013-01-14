ActiveAdmin.register ShipMethod do
  menu if: proc { can? :manage, ShipMethod }
  controller.authorize_resource

  index do
    selectable_column

    column :name, :sortable => :name
    column :cost, :sortable => :cost
    column :method, :sortable => :method do |ship_method|
      t(ship_method.method)
    end
    column :service_phone

    default_actions
  end

  show do
    attributes_table do
      row :name
      row :cost
      row :method do |shipmethod|
        t(shipmethod.method)
      end
      row :service_phone
      row :website
      row :kuaidi_com_code
    end
  end

end
