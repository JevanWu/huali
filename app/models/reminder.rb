class Reminder < ActiveRecord::Base
  attr_accessible :email, :send_date, :note

  validates_presence_of :email, :send_date
end
