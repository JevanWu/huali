# == Schema Information
#
# Table name: collections
#
#  available        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  description      :string(255)
#  display_name     :string(255)
#  id               :integer          not null, primary key
#  meta_description :string(255)
#  meta_keywords    :string(255)
#  meta_title       :string(255)
#  name_en          :string(255)      not null
#  name_zh          :string(255)      not null
#  primary_category :boolean          default(FALSE), not null
#  priority         :integer          default(5)
#  slug             :string(255)
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_collections_on_slug  (slug) UNIQUE
#

class Collection < ActiveRecord::Base
  attr_accessible :description, :name_en, :name_zh, :display_name,
                  :available, :meta_description,:meta_title, :meta_keywords, :primary_category, :priority

  has_and_belongs_to_many :products

  validates_presence_of :display_name, :name_zh

  translate :name

  extend FriendlyId
  friendly_id :name_en, use: :slugged

  scope :available, lambda { where(available: true) }
  scope :primary, lambda { where(primary_category: true) }

  default_scope lambda { order('priority DESC') }

  def to_s
    "#{self.id} #{self.name_zh}"
  end

  def suggest_by_random(amount = 4)
    r = []
    self.products.published.select("id").sample(amount).each do |t|
      r.push(t.id)
    end
    r
  end

  def suggest_by_priority(amount = 4)
    r = []
    self.products.published.order("priority desc").limit((amount*1.2).round).each do |t|
      r.push(t.id)
    end
    r
  end

  def suggest_by_sold_total(amount = 4)
    r = []
    self.products.published.order("sold_total desc").limit((amount*1.2).round).each do |t|
      r.push(t.id)
    end
    r
  end
end
