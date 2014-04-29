ActiveAdmin.register PrintOrder do
  menu parent: '订单打印', if: proc { authorized? :read, PrintOrder }
  actions :index

  filter :print_group
  filter :order_printed
  filter :card_printed
  filter :shipment_printed

  index do
    column :order do |print_order|
      link_to print_order.order.identifier, admin_order_path(print_order.order)
    end

    column :print_group do |print_order|
      link_to print_order.print_group.name, admin_print_group_path(print_order.print_group)
    end

    column :order_printed
    column :card_printed
    column :shipment_printed
  end

end
