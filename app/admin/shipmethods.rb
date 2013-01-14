ActiveAdmin.register ShipMethod do
  menu if: proc { can? :manage, ShipMethod }
  controller.authorize_resource

  index do
    selectable_column

    column :name, :sortable => :name
    column :cost, :sortable => :cost
    column :method, :sortable => :method
    column :service_phone
  end

  show do
    attributes_table do
      row :name
      row :cost
      row :method
      row :service_phone
      row :website
      row :kuaidi_com_code
    end
  end

end
