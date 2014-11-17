class CreateLuckyDrawOfflinePrizeGenerators < ActiveRecord::Migration
  def change
    create_table :lucky_draw_offline_prize_generators do |t|

      t.timestamps
    end
  end
end
