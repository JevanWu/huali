class CreateLuckyDrawOfflines < ActiveRecord::Migration
  def change
    create_table :lucky_draw_offlines do |t|
      t.string :gender
      t.string :name
      t.integer :mobile
      t.string :prize
      t.timestamps
    end
  end
end
