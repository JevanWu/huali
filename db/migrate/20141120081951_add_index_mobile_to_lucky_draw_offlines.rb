class AddIndexMobileToLuckyDrawOfflines < ActiveRecord::Migration
  def change
    add_index :lucky_draw_offlines, :mobile, unique: true
  end
end
