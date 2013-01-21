# encoding: utf-8
ActiveAdmin.register_page "Resque" do
  controller.authorize_resource
  menu parent: '设置', :priority => 2, if: proc { can? :read, Resque }
end
