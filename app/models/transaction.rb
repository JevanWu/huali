class Transaction < ActiveRecord::Base
  attr_accessible :amount, :identifier, :status

  belongs_to :order, :dependent => :destroy

end
