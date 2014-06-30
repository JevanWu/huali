# == Schema Information
#
# Table name: postcards
#
#  answer     :string(255)
#  content    :text
#  created_at :datetime
#  id         :integer          not null, primary key
#  identifier :string(255)
#  order_id   :integer
#  question   :string(255)
#  slug       :string(255)
#  updated_at :datetime
#
# Indexes
#
#  index_postcards_on_identifier  (identifier)
#  index_postcards_on_order_id    (order_id)
#

class Postcard < ActiveRecord::Base
  validates :identifier, uniqueness: true
  has_many :assets, as: :viewable, dependent: :destroy
  belongs_to :order
  accepts_nested_attributes_for :assets, reject_if: lambda { |a| a[:image].blank? }, allow_destroy: true

  extend FriendlyId
  friendly_id :identifier, use: :slugged
end
