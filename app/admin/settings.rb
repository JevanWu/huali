# encoding: utf-8
ActiveAdmin.register Setting do
  menu parent: "设置", if: proc { authorized? :manage, Setting }
  actions :index, :edit, :show, :update, :new, :create

  config.filters = false
  
  index do
    column :id
    column :var
    column :thing_id
    column :thing_type

    default_actions
  end

  form partial: 'form'

  controller do
    def permitted_params
      params.require(:setting).permit(:var, :value)
    end
  end
end
