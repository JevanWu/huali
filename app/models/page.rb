# == Schema Information
#
# Table name: pages
#
#  content          :text
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  meta_description :string(255)
#  meta_keywords    :string(255)
#  permalink        :string(255)
#  title            :string(255)
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

  attr_accessible :content_en, :content_zh, :title_en, :title_zh, :permalink, :meta_description, :meta_keywords

  validates :permalink, :exclusion => { :in => reserved_words, :message => "%{value} is reserved" }

  validates_uniqueness_of :permalink

  # i18n translation
  # FIXME need a better way to autoload the extended methods
  require './lib/models.rb'
  translate :title, :content

  def to_param
    permalink
  end
end
