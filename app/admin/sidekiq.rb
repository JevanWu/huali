# encoding: utf-8
ActiveAdmin.register_page "Sidekiq" do
  controller.authorize_resource
  menu parent: '设置', priority: 2,  if: proc { authorized? :read, Sidekiq }
end
