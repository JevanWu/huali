# == Schema Information
#
# Table name: collections
#
#  available             :boolean          default(FALSE)
#  created_at            :datetime         not null
#  description           :string(255)
#  display_name          :string(255)
#  display_on_breadcrumb :boolean          default(FALSE)
#  id                    :integer          not null, primary key
#  meta_description      :string(255)
#  meta_keywords         :string(255)
#  meta_title            :string(255)
#  name_en               :string(255)      not null
#  name_zh               :string(255)      not null
#  parent_id             :integer
#  primary_category      :boolean          default(FALSE), not null
#  priority              :integer          default(5)
#  slug                  :string(255)
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_collections_on_slug  (slug) UNIQUE
#

class Collection < ActiveRecord::Base
  # FIXME disallow removal of collection when it has associated products
  has_and_belongs_to_many :products

  validates_presence_of :display_name, :name_zh

  acts_as_tree name_column: 'display_name', order: 'priority'

  translate :name

  extend FriendlyId
  friendly_id :name_en, use: :slugged

  scope :display_on_breadcrumb, -> { where(display_on_breadcrumb: true).order(:priority) }
  scope :available, -> { where(available: true) }
  scope :primary, -> { where(primary_category: true) }

  def show_name
    display_name || name
  end

  def to_s
    "#{self.id} #{self.name_zh}"
  end

  class << self
    def parents_options(id)
      parse_tree(hash_tree, id)
    end

    private

    def parse_tree(tree, exclude)
      tree.map do |k, v|
        next [] if k.id == exclude

        parent = [[option_name(k.show_name, k.depth), k.id]]

        if v.present?
          parent.concat parse_tree(v, exclude)
        end

        parent
      end.reduce(&:concat)
    end

    def option_name(name, depth)
      new_name = name

      depth.times do
        new_name = '&nbsp;' * 3 + new_name
      end

      new_name.html_safe
    end
  end
end
