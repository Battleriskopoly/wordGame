class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :game_id
      t.text :content
      t.string :user_name
      t.integer :vote_number

      t.timestamps null: false
    end
  end
end
