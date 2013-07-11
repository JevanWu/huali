ActiveAdmin.register Administrator do
  menu priority: 1, if: proc { authorized? :read, Administrator }

  filter :role
  filter :email

  controller do
    def permitted_params
      params
        .require(:administrator)
        .permit(:email, :password, :role)
    end
  end

  index do
    selectable_column
    column :email
    column :role
    column :last_sign_in_at
    default_actions
  end

  form partial: "form"

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
