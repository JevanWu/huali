ActiveAdmin.register Province do
  menu parent: -> { I18n.t('active_admin.menu.setting') }, if: proc { can? :read, Province }

  controller do
    include ActiveAdminCanCan
    authorize_resource
  end

  scope :available
  scope :unavailable

  [ :enable,
    :disable
  ].each do |action|
      batch_action -> { I18n.t(action) } do |selection|
        provinces = Province.find(selection)
        provinces.each { |province| province.send(action) }
        redirect_to :back, :notice => provinces.count.to_s + t(:province_updated)
      end
    end
  batch_action :destroy, false

  member_action :enable  do
    province = Province.find_by_id(params[:id])
    province.available = true
    if province.save!
      redirect_to admin_province_path(province), :alert => "#{province.name} is enabled."
    end
  end

  member_action :disable  do
    province = Province.find_by_id(params[:id])
    province.available = false
    if province.save!
      redirect_to admin_province_path(province), :alert => "#{province.name} is disabled."
    end
  end

  index do
    selectable_column
    column :name do |prov|
      link_to prov.name, admin_province_path(prov)
    end
    column :post_code
    column :available
    column :modify_province do |province|
      if province.available == true
        link_to :disable, disable_admin_province_path(province)
      else
        link_to :enable, enable_admin_province_path(province)
      end
    end
  end

  show do
    attributes_table do
      row :name
      row :post_code
      row :available
      row :cities do
        province.cities.map do |city|
          link_to city.name, admin_city_path(city)
        end.join(', ').html_safe
      end
      row :modify_province do |province|
        if province.available == true
          link_to :disable, disable_admin_province_path(province)
        else
          link_to :enable, enable_admin_province_path(province)
        end
      end
    end
  end
end

ActiveAdmin.register City do
  menu parent: I18n.t('active_admin.menu.setting'), if: proc { can? :read, City }

  controller do
    include ActiveAdminCanCan
    authorize_resource
  end

  scope :available
  scope :unavailable

  filter :province,
    as: :select,
    collection: proc { Province.unscoped.reduce({}) { |m, p| m[p.name] = p.post_code; m } }

  [ :enable,
    :disable
  ].each do |action|
      batch_action I18n.t(action) do |selection|
        cities = City.find(selection)
        cities.each { |city| city.send(action) }
        redirect_to :back, :notice => cities.count.to_s + t(:city_updated)
      end
    end
  batch_action :destroy, false

  member_action :enable  do
    city = City.find_by_id(params[:id])
    city.available = true
    if city.save!
      redirect_to admin_city_path(city), :alert => "#{city.name} is enabled."
    end
  end

  member_action :disable  do
    city = City.find_by_id(params[:id])
    city.available = false
    if city.save!
      redirect_to admin_city_path(city), :alert => "#{city.name} is disabled."
    end
  end

  index do
    selectable_column
    column :name do |city|
      link_to city.name, admin_city_path(city)
    end
    column :province
    column :post_code
    column :available
    column :modify_city do |city|
      if city.available == true
        link_to :disable, disable_admin_city_path(city)
      else
        link_to :enable, enable_admin_city_path(city)
      end
    end
  end

  show do
    attributes_table do
      row :name
      row :province
      row :post_code
      row :available
      row :cities do
        city.areas.map do |area|
          link_to area.name, admin_area_path(area)
        end.join(', ').html_safe
      end
      row :modify_city do |city|
        if city.available == true
          link_to :disable, disable_admin_city_path(city)
        else
          link_to :enable, enable_admin_city_path(city)
        end
      end
    end
  end
end

ActiveAdmin.register Area do
  menu parent: I18n.t('active_admin.menu.setting'), if: proc { can? :read, Area }

  controller do
    include ActiveAdminCanCan
    authorize_resource
  end

  scope :available
  scope :unavailable

  [ :enable,
    :disable
  ].each do |action|
      batch_action I18n.t(action) do |selection|
        areas = Area.find(selection)
        areas.each { |area| area.send(action) }
        redirect_to :back, :notice => areas.count.to_s + t(:area_updated)
      end
    end
  batch_action :destroy, false

  member_action :enable  do
    area = Area.find_by_id(params[:id])
    area.available = true
    if area.save!
      redirect_to admin_area_path(area), :alert => "#{area.name} is enabled."
    end
  end

  member_action :disable  do
    area = Area.find_by_id(params[:id])
    area.available = false
    if area.save!
      redirect_to admin_area_path(area), :alert => "#{area.name} is disabled."
    end
  end

  index do
    selectable_column
    column :name do |area|
      link_to area.name, admin_area_path(area)
    end
    column :city
    column :province do |area|
      link_to area.city.province.name, admin_province_path(area.city.province)
    end
    column :post_code
    column :available
    column :modify_area do |area|
      if area.available == true
        link_to :disable, disable_admin_area_path(area)
      else
        link_to :enable, enable_admin_area_path(area)
      end
    end
  end

  show do
    attributes_table do
      row :name
      row :city
      row :post_code
      row :available
      row :modify_area do |area|
        if area.available == true
          link_to :disable, disable_admin_area_path(area)
        else
          link_to :enable, enable_admin_area_path(area)
        end
      end
    end
  end
end
