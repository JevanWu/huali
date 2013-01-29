ActiveAdmin.register Administrator do
  menu :priority => 1, if: proc { can? :read, Administrator }
  controller.authorize_resource

  filter :role
  filter :email

  index do
    selectable_column
    column :email
    column :role
    column :last_sign_in_at
    default_actions
  end

  form :partial => "form"

  show do
    attributes_table do
      row :email
      row :role
      row :current_sign_in_at
      row :last_sign_in_at
      row :sign_in_count
    end
  end
end
