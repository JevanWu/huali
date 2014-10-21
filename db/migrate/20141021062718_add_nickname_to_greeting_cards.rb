class AddNicknameToGreetingCards < ActiveRecord::Migration
  def change
    add_column :greeting_cards, :sender_nickname, :string
    add_column :greeting_cards, :recipient_nickname, :string
  end
end
