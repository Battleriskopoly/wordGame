class AddEntryIdToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :entry_id, :integer
    add_column :votes, :game_id, :integer
  end
end
