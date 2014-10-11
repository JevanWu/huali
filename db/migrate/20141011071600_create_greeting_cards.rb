class CreateGreetingCards < ActiveRecord::Migration
  def change
    create_table :greeting_cards do |t|

      t.timestamps
    end
  end
end
