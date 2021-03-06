ActiveAdmin.register Administrator do
  menu priority: 1, if: proc { authorized? :read, Administrator }

  filter :role
  filter :email

  controller do
    private

    def permitted_params
      params.permit(administrator: [:email, :password, :role])
    end
  end

  index do
    selectable_column
    column :email

    column :role, sortable: :role do |admin|
      admin.role_text
    end

    column :last_sign_in_at
    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :email
      row :role do
        administrator.role_text
      end
      row :current_sign_in_at
      row :last_sign_in_at
      row :sign_in_count
    end
  end
end
