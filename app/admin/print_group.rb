ActiveAdmin.register PrintGroup do
  menu parent: '订单打印', if: proc { authorized? :read, PrintGroup }

  controller do
    def permitted_params
      params.permit(print_group: [:name, :ship_method_id])
    end
  end

  form partial: "form"

  index do
    column :name
    column :ship_method
  end


  show do
    attributes_table do
      row :name
      row :ship_method
      row :created_at
      row :updated_at
    end
  end
end
