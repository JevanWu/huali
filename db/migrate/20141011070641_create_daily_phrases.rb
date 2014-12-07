class CreateDailyPhrases < ActiveRecord::Migration
  def change
    create_table :daily_phrases do |t|
      t.string :title
      t.text :phrase
      t.attachment :image

      t.timestamps
    end
  end
end
