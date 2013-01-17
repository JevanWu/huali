ActiveAdmin.register_page "Resque" do
  controller.authorize_resource
  menu :priority => 1, if: proc { can? :manage, Resque }
end
