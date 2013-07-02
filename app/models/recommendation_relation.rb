# == Schema Information
#
# Table name: recommendation_relations
#
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  product_id        :integer
#  recommendation_id :integer
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_recommendation_relations_on_product_id         (product_id)
#  index_recommendation_relations_on_recommendation_id  (recommendation_id)
#

class RecommendationRelation < ActiveRecord::Base
  belongs_to :product
  belongs_to :recommendation, :class_name => "Product"
end
