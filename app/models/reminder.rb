class Reminder < ActiveRecord::Base
  attr_accessible :email, :send_date, :note

end
