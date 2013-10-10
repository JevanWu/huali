# encoding: utf-8
ActiveAdmin.register Banner do
  menu parent: "设置", if: proc { authorized? :manage, Banner }

  controller do
    private

    def permitted_params
      params.permit(banner: [:name, :content, :start_date, :end_date])
    end
  end

  form partial: "form"
end
