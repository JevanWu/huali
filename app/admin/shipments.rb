# encoding: utf-8
ActiveAdmin.register Shipment do
  menu(:label => "递送")
  #actions :all, :except => :new
  index do
    selectable_column

    column "ID", :sortable => :id do |shipment|
      link_to shipment.id, admin_shipment_path(shipment)
    end
    
    column "成本", :sortable => :cost do |shipment|
      shipment.cost
    end

    column "递送状态", :sortable => :state do |shipment|
      shipment.state ? t(shipment.state) : nil
    end

    column "递送编号", :sortable => :identifier do |shipment|
      shipment.identifier
    end

    column "跟踪编号", :sortable => :tracking_num do |shipment|
      shipment.tracking_num
    end

    default_actions

  end

  form :partial => "form"

  show :title => "递送" do

    attributes_table do
      row '成本' do
        shipment.cost
      end

      row '递送编号' do
        shipment.identifier
      end

      row '递送状态' do
        shipment.state ? t(shipment.state) : nil
      end

      row '留言' do
        shipment.note
      end

      row '快递单号' do
        shipment.tracking_num
      end

    end
  end

end
