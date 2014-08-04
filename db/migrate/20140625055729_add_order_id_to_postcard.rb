class AddOrderIdToPostcard < ActiveRecord::Migration
  def change
    add_reference :postcards, :order, index: true
  end
end
