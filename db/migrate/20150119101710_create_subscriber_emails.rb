class CreateSubscriberEmails < ActiveRecord::Migration
  def change
    create_table :subscriber_emails do |t|
      t.string :email

      t.timestamps

    end

    add_index :subscriber_emails, :email, unique: true
  end
end
