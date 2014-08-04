class CreatePostcards < ActiveRecord::Migration
  def change
    create_table :postcards do |t|
      t.string :identifier
      t.text :content
      t.string :question
      t.string :answer

      t.timestamps
    end
    
    add_index(:postcards, :identifier)
  end
end
