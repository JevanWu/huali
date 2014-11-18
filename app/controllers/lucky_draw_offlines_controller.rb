class LuckyDrawOfflinesController < ApplicationController
  def new
    @lucky_draw_offline = LuckyDrawOffline.new
  end
  def create
    binding.pry and return
    @lucky_draw_offline = LuckyDrawOffline.new(lucky_draw_offline_params)
    LuckyDrawOfflinePrizeGenerator.init
    @lucky_draw_offline.prize = LuckyDrawOfflinePrizeGenerator.generate
  end
  def show

  end

  private
  def lucky_draw_offline_params
    params.require(:lucky_draw_offline).permit(:gender, :name, :mobile)
  end
end
