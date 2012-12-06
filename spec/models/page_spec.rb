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

require 'spec_helper'

describe Page do
  pending "add some examples to (or delete) #{__FILE__}"
end
