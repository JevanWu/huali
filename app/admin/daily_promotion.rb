ActiveAdmin.register DailyPromotion do
  menu parent: '设置', if: proc { authorized? :read, DailyPromotion }

  index do
    column :day do |daily_promotion|
      daily_promotion.day.strftime("%Y-%m-%d %A")
    end

    column :product do |daily_promotion|
      link_to(daily_promotion.product.name_zh, admin_product_path(daily_promotion.product))
    end

    column :created_at
    column :updated_at
    actions
  end

  controller do
    def create
      super do |format|
        redirect_to collection_url, notice: t('active_admin.notice.created') and return if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to collection_url, notice: t('active_admin.notice.updated') and return if resource.valid?
      end
    end

    private
    def permitted_params
      params.permit(daily_promotion: [:day, :product_id])
    end
  end

  form partial: "form"
end
