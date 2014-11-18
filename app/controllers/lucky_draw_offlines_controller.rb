class LuckyDrawOfflinesController < ApplicationController
  before_action :authenticate_administrator!
  def new
    @lucky_draw_offline = LuckyDrawOffline.new
  end
  def create
    @lucky_draw_offline = LuckyDrawOffline.new(lucky_draw_offline_params)
    LuckyDrawOfflinePrizeGenerator.init
    @lucky_draw_offline.prize = LuckyDrawOfflinePrizeGenerator.generate
    if @lucky_draw_offline.save
      redirect_to lucky_draw_offline_path
    else
      render "new"
    end
  end
  def result
    @lucky_draw_offline = LuckyDrawOffline.find(params[:id])
  end

  private
  def lucky_draw_offline_params
    params.require(:lucky_draw_offline).permit(:gender, :name, :mobile)
  end
end
