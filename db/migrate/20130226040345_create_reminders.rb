class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :email, null: false
      t.datetime :send_date, null: false
      t.text :note

      t.timestamps
    end
  end
end
