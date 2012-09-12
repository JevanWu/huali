class Product < ActiveRecord::Base

  attr_accessible :name_cn, :name_en, :description, :meta_description, :meta_keywords, :count_on_hand, :cost_price, :price, :height, :width, :depth, :available_on, :deleted_at

  def has_stock?

  end

  def available?

  end

end
