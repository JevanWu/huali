class CreateReplyGreetingCards < ActiveRecord::Migration
  def change
    create_table :reply_greeting_cards do |t|
      t.references :greeting_card, index: true
      t.text :response
      t.timestamps
    end
  end
end
