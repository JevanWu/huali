# == Schema Information
#
# Table name: featured_products
#
#  available          :boolean          default(TRUE)
#  cover_content_type :string(255)
#  cover_file_name    :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#  created_at         :datetime
#  description        :text
#  id                 :integer          not null, primary key
#  priority           :integer
#  product_id         :integer
#  updated_at         :datetime
#
# Indexes
#
#  index_featured_products_on_product_id  (product_id)
#


require 'spec_helper'

describe FeaturedProduct do
  pending "add some examples to (or delete) #{__FILE__}"
end
