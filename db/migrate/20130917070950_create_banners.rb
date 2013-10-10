class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :name
      t.string :content
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
