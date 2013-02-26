# encoding: utf-8
ActiveAdmin.register_page "Sidekiq" do
  controller.authorize_resource
  menu parent: '设置', priority: 2,  if: proc { can? :read, Sidekiq }
end
