class AddAgeBracketToLuckyDrawOfflines < ActiveRecord::Migration
  def change
    add_column :lucky_draw_offlines, :age_bracket, :string
  end
end
