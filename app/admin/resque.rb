ActiveAdmin.register_page "Resque" do
  controller.authorize_resource
  menu parent: I18n.t('active_admin.menu.setting'), :priority => 2, if: proc { can? :read, Resque }
end
