# == Schema Information
#
# Table name: point_transactions
#
#  created_at       :datetime
#  description      :string(255)
#  expires_on       :date
#  id               :integer          not null, primary key
#  point            :integer          default(0)
#  transaction_id   :integer
#  transaction_type :string(255)
#  updated_at       :datetime
#  user_id          :integer
#
# Indexes
#
#  index_point_transactions_on_transaction_id  (transaction_id)
#  index_point_transactions_on_user_id         (user_id)
#

class PointTransaction < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  belongs_to :transaction

  enumerize :transaction_type, in: [:income, :expense]
end
