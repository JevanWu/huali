class Page < ActiveRecord::Base
  reserved_words = [
    'account', 'admin', 'api', 'blog', 'cache', 'changelog', 'enterprise', 'help', 'jobs', 'lists',
    'login', 'logout', 'mine', 'news', 'plans', 'popular', 'projects', 'security', 'shop', 'session',
    'jobs', 'translations', 'signup', 'status', 'styleguide', 'tour', 'wiki', 'stories', 'organizations',
    'restaurant', 'codereview', 'better', 'compare', 'hosting' ]

  attr_accessible :content, :title, :permalink, :meta_description, :meta_keywords

  validates :permalink, :exclusion => { :in => reserved_words, :message => "%{value} is reserved" }

  validates_uniqueness_of :permalink

  def to_param
    permalink
  end


end
