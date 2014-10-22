class AddNicknameToGreetingCards < ActiveRecord::Migration
  def change
    add_column :greeting_cards, :sender_nickname, :string, default: '', null: false
    add_column :greeting_cards, :recipient_nickname, :string, default: '', null: false
  end
end
