ActiveAdmin.register ShipMethod do
  menu parent: I18n.t('active_admin.menu.setting'), if: proc { can? :read, ShipMethod }

  controller do
    include ActiveAdminCanCan
    authorize_resource
  end

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
