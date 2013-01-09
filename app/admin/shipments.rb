# encoding: utf-8
ActiveAdmin.register Shipment do
  menu :if => proc{ can?(:manage, Shipment) }
  controller.authorize_resource

  #actions :all, :except => :new
  index do
    selectable_column
    
    column :tracking_num, :sortable => :tracking_num
    column :cost, :sortable => :cost
    column :state, :sortable => :state do |shipment|
      shipment.state ? t(shipment.state) : nil
    end
    default_actions

  end

  form :partial => "form"

  show do

    attributes_table do
      row :tracking_num
      row :cost
      row :state do
        shipment.state ? t(shipment.state) : nil
      end
      row :note
    end
  end

end
