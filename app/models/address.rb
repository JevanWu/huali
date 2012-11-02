class Address < ActiveRecord::Base
  belongs_to :province
  belongs_to :city
  belongs_to :area
  attr_accessible :address, :fullname, :phone, :post_code
end
