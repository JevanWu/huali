ActiveAdmin.register Administrator do
  menu priority: 1, if: proc { authorized? :read, Administrator }

  filter :role
  filter :email

  controller do
    before_action :authorize_creating_super, only: [:create, :update]

    private

    def authorize_creating_super
      if params[:administrator][:role] == "super"
        current_admin_ability.authorize! :create_super, Administrator
      end
    end

    def permitted_params
      params.permit(administrator: [:email, :password, :role])
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
