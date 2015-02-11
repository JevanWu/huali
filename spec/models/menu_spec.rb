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



require 'spec_helper'

describe Menu do
  pending "add some examples to (or delete) #{__FILE__}"
end
