# == Schema Information
#
# Table name: pages
#
#  content_en       :text
#  content_zh       :text
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  in_footer        :boolean          default(TRUE)
#  meta_description :string(255)
#  meta_keywords    :string(255)
#  meta_title       :string(255)
#  permalink        :string(255)
#  title_en         :string(255)
#  title_zh         :string(255)
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_pages_on_permalink  (permalink)
#

class Page < ActiveRecord::Base

  reserved_words = [
    'account',
    'admin',
    'api',
    'blog',
    'cache',
    'changelog',
    'enterprise',
    'help',
    'jobs',
    'lists',
    'login',
    'logout',
    'mine',
    'news',
    'plans',
    'popular',
    'projects',
    'security',
    'shop',
    'session',
    'jobs',
    'translations',
    'signup',
    'status',
    'styleguide',
    'tour',
    'wiki',
    'stories',
    'organizations',
    'restaurant',
    'codereview',
    'better',
    'compare',
    'hosting'
  ]

  validates :permalink, exclusion: { in: reserved_words, message: "%{value} is reserved" }

  validates_presence_of :permalink, :title_zh
  validates_uniqueness_of :permalink

  scope :in_footer, -> { where(in_footer: true) }

  # i18n translation
  translate :title, :content

  def to_param
    permalink
  end
end
