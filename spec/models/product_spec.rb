# == Schema Information
#
# Table name: products
#
#  available        :boolean          default(TRUE)
#  collection_id    :integer
#  cost_price       :decimal(8, 2)
#  count_on_hand    :integer          default(0), not null
#  created_at       :datetime         not null
#  depth            :decimal(8, 2)
#  description      :text
#  height           :decimal(8, 2)
#  id               :integer          not null, primary key
#  info_source      :text
#  inspiration      :text
#  meta_description :string(255)
#  meta_keywords    :string(255)
#  name_char        :string(255)
#  name_cn          :string(255)      default(""), not null
#  name_en          :string(255)      default(""), not null
#  original_price   :decimal(, )
#  price            :decimal(8, 2)
#  related_text     :text
#  slug             :string(255)
#  updated_at       :datetime         not null
#  width            :decimal(8, 2)
#
# Indexes
#
#  index_products_on_name_en  (name_en)
#  index_products_on_slug     (slug) UNIQUE
#

require 'spec_helper'

describe Product do
  pending "add some examples to (or delete) #{__FILE__}"
end
