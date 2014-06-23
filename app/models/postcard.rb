# == Schema Information
#
# Table name: postcards
#
#  answer     :string(255)
#  content    :text
#  created_at :datetime
#  id         :integer          not null, primary key
#  identifier :string(255)
#  question   :string(255)
#  updated_at :datetime
#
# Indexes
#
#  index_postcards_on_identifier  (identifier)
#

class Postcard < ActiveRecord::Base
  validates :identifier, uniqueness: true
  has_many :assets, as: :viewable, dependent: :destroy
end
