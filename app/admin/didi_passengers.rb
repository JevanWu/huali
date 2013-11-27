# encoding: utf-8
ActiveAdmin.register DidiPassenger do
  menu parent: '设置', if: proc { authorized? :read, DidiPassenger }
  actions :index

  filter :phone
  filter :created_at

  index do
    selectable_column
    column :phone
    column :coupon_code do |didi_passenger|
      coupon_code = didi_passenger.coupon_code
      unless coupon_code.nil?
        link_to coupon_code, admin_coupon_path(coupon_code.coupon), target: '_blank'
      end
    end
    column :created_at
  end
end

