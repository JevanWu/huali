# == Schema Information
#
# Table name: menus
#
#  available     :boolean          default(TRUE)
#  collection_id :integer
#  created_at    :datetime
#  id            :integer          not null, primary key
#  link          :string(255)
#  name          :string(255)
#  parent_id     :integer
#  priority      :integer
#  updated_at    :datetime
#
# Indexes
#
#  index_menus_on_collection_id  (collection_id)
#



class Menu < ActiveRecord::Base
  belongs_to :collection
  validates :name, presence: true
  acts_as_tree

  scope :available, -> { where(available: true) }
  scope :unavailable, -> { where(available: false) }
end
