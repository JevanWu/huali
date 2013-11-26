class CreateDidiPassengers < ActiveRecord::Migration
  def change
    create_table :didi_passengers do |t|
      t.string :name
      t.string :phone
      t.references :coupon_code, index: true

      t.timestamps
    end
  end
end
