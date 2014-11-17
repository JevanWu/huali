class CreateLuckyDrawOfflines < ActiveRecord::Migration
  def change
    create_table :lucky_draw_offlines do |t|
      t.string :gender
      t.string :name
      t.string :mobile
      t.timestamps
    end
  end
end
