ActiveAdmin.register_page "Resque" do
  controller.authorize_resource
  menu :priority => 2, if: proc { can? :read, Resque }
end
