# encoding: UTF-8
ActiveAdmin.register Administrator do
  menu :priority => 1, :if => proc{ can?(:manage, Administrator) }
  controller.authorize_resource
end
