class LuckyDrawOfflinesController < ApplicationController
  before_action :authenticate_administrator!
  def new
    @lucky_draw_offline = LuckyDrawOffline.new
  end
  def create
    @lucky_draw_offline = LuckyDrawOffline.new(lucky_draw_offline_params)
    LuckyDrawOfflinePrizeGenerator.init do |prize_generator| 
      @lucky_draw_offline.prize = prize_generator.generate
    end
    if @lucky_draw_offline.save
      case @lucky_draw_offline.prize
      when "a"
        render "result_a"
      when "b"
        render "result_b"
      when "c"
        render "result_c"
      end
    else
      render "new"
    end
  end

  private
  def lucky_draw_offline_params
    params.require(:lucky_draw_offline).permit(:gender, :name, :mobile)
  end
end
