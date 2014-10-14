class CreateReplyGreetingCards < ActiveRecord::Migration
  def change
    create_table :reply_greeting_cards do |t|

      t.timestamps
    end
  end
end
