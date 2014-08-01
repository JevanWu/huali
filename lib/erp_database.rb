class ErpDatabase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "erp_#{Rails.env}"
end
