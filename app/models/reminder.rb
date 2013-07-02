# == Schema Information
#
# Table name: reminders
#
#  created_at :datetime         not null
#  email      :string(255)      not null
#  id         :integer          not null, primary key
#  note       :text
#  send_date  :datetime         not null
#  updated_at :datetime         not null
#

class Reminder < ActiveRecord::Base
  attr_accessible :email, :send_date, :note

  validates_presence_of :email, :send_date
end
