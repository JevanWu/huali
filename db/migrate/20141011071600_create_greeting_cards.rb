class CreateGreetingCards < ActiveRecord::Migration
  def change
    create_table :greeting_cards do |t|
      t.references :user, index: true
      t.references :product, index: true
      t.string :sender_email
      t.string :recipient_email
      t.text :sentiments
      t.string :uuid
      t.timestamps
    end
  end
end
