# encoding: utf-8
ActiveAdmin.register_page "Global Settings" do
  menu parent: "设置", label: -> { I18n.t("active_admin.global_settings") }, if: proc { authorized? :manage, Settings }

  content :title => proc{ I18n.t("active_admin.global_settings")  } do
  end

  controller do
    def edit_product_rules
      @product = OpenStruct.new(date_rule: OpenStruct.new, region_rule: OpenStruct.new)
      @product.date_rule.start_at = nil
      @product.date_rule.end_at = nil
      @product.date_rule.included_dates = []
      @product.date_rule.excluded_dates = []
      @product.date_rule.excluded_weekdays = []
    end
  end
end
