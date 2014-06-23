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

require 'spec_helper'

describe Postcard do
  pending "add some examples to (or delete) #{__FILE__}"
end
