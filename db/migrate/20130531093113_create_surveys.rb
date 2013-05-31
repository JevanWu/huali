class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :user_id
      t.string :gender
      t.string :receiver_gender
      t.string :gift_purpose

      t.timestamps
    end
  end
end
