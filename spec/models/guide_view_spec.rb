# == Schema Information
#
# Table name: guide_views
#
#  available          :boolean          default(FALSE)
#  created_at         :datetime
#  description        :text
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  priority           :integer
#  updated_at         :datetime
#

require 'spec_helper'

describe GuideView do
  pending "add some examples to (or delete) #{__FILE__}"
end
