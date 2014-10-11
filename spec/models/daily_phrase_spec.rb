# == Schema Information
#
# Table name: daily_phrases
#
#  created_at         :datetime
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  phrase             :text
#  title              :string(255)
#  updated_at         :datetime
#

require 'spec_helper'

describe DailyPhrase do
  pending "add some examples to (or delete) #{__FILE__}"
end
