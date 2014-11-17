class CreateLuckyDrawOfflines < ActiveRecord::Migration
  def change
    create_table :lucky_draw_offlines do |t|

      t.timestamps
    end
  end
end
