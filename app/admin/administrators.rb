ActiveAdmin.register Administrator do
  menu :priority => 1, if: proc { can? :read, Administrator }
  controller.authorize_resource
end
