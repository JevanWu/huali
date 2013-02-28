ActiveAdmin.register User do
  menu priority: 1, if: proc { can? :read, User }
  controller.authorize_resource

  filter :email
  scope :guests
  scope :non_guests
  scope :all

  index do
    selectable_column
    column :email
    column :sign_in_count
    column :last_sign_in_at
    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :email
      row :last_sign_in_at
      row :sign_in_count
    end
  end
end
