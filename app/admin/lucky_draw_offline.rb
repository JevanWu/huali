ActiveAdmin.register LuckyDrawOffline do

  filter :mobile
  filter :gender, as: :select, collection: LuckyDrawOffline.gender.options
  filter :prize, as: :select, collection: LuckyDrawOffline.prize.options
  filter :age_bracket, as: :select, collection: LuckyDrawOffline.age_bracket.options

  collection_action :export_excel, method: :get do
  end

  collection_action :download, method: :get do
    start_date = params[:start_date].values.join('-')
    end_date = params[:end_date].values.join('-')
    filename = "/tmp/lucky_draw_offline-#{start_date}-#{end_date}-#{Time.current.to_i}.xlsx"
    record = LuckyDrawOffline.where('created_at >= ? AND created_at < ? ', start_date, end_date)

    Axlsx::Package.new do |p|
      p.use_autowidth = false
      p.workbook.add_worksheet(:name => "LuckyDrawOffline") do |sheet|
        sheet.add_row %w[手机号 性别 奖品 年龄层 创建时间]
        record.each do |lucky_draw_offline|
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
        link_to('export excel', params.merge(action: :export_excel), class: 'table_tools_button')
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
