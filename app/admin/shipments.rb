# encoding: utf-8
ActiveAdmin.register Shipment do
  menu(:label => "递送")
  #actions :all, :except => :new
  index do
    selectable_column
    
    column :identifier
    column :cost, :sortable => :cost
    column :state, :sortable => :state do |shipment|
      shipment.state ? t(shipment.state) : nil
    end
    column :tracking_num, :sortable => :tracking_num
    default_actions

  end

  form :partial => "form"

  show do

    attributes_table do
      row :identifier
      row :cost
      row :state do
        shipment.state ? t(shipment.state) : nil
      end
      row :note
      row :tracking_num
    end
  end

end
