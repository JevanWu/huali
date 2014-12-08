# == Schema Information
#
# Table name: lucky_draw_offlines
#
#  age_bracket :string(255)
#  created_at  :datetime
#  gender      :string(255)
#  id          :integer          not null, primary key
#  mobile      :string(255)
#  name        :string(255)
#  prize       :string(255)
#  updated_at  :datetime
#
# Indexes
#
#  index_lucky_draw_offlines_on_mobile  (mobile) UNIQUE
#

require 'spec_helper'

describe LuckyDrawOffline do
  pending "add some examples to (or delete) #{__FILE__}"
end
