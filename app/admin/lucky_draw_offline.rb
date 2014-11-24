ActiveAdmin.register LuckyDrawOffline do

  filter :mobile
  filter :gender, as: :select, collection: LuckyDrawOffline.gender.options
  filter :prize, as: :select, collection: LuckyDrawOffline.prize.options
  filter :age_bracket, as: :select, collection: LuckyDrawOffline.age_bracket.options

  collection_action :download_excel_report, method: :get do
    filename = "/tmp/lucky_draw_offline.xlsx"

    Axlsx::Package.new do |p|
      p.use_autowidth = false
      p.workbook.add_worksheet(:name => "LuckyDrawOffline") do |sheet|
        sheet.add_row %w[手机号 性别 奖品 年龄层 创建时间]
        LuckyDrawOffline.all.each do |lucky_draw_offline|
          array = []
          array << lucky_draw_offline.mobile
          array << lucky_draw_offline.gender_text
          array << lucky_draw_offline.prize_text
          array << lucky_draw_offline.age_bracket_text
          array << lucky_draw_offline.updated_at.to_s
          sheet.add_row array
        end
      end
      p.serialize(filename)
    end

    send_file filename, x_sendfile: true, type: Mime::Type.lookup_by_extension(:xlsx).to_s
  end

  index do
      div style: "text-align: right" do
        link_to('download excel report', params.merge(action: :download_excel_report), class: 'table_tools_button')
      end

    column :mobile do |lucky_draw_offline|
      lucky_draw_offline.mobile
    end
    column :gender do |lucky_draw_offline|
      lucky_draw_offline.gender_text
    end
    column :prize do |lucky_draw_offline|
      lucky_draw_offline.prize_text
    end
    column :age_bracket do |lucky_draw_offline|
      lucky_draw_offline.age_bracket_text
    end
    column :created_at
    actions
  end

end
