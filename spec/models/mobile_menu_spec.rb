# == Schema Information
#
# Table name: mobile_menus
#
#  created_at         :datetime
#  description        :text
#  href               :string(255)
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  name               :string(255)
#  priority           :integer
#  updated_at         :datetime
#

require 'spec_helper'

describe MobileMenu do
  pending "add some examples to (or delete) #{__FILE__}"
end
