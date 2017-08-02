class AddIdToPlayerColumn < ActiveRecord::Migration
  def change
    rename_column :games, :player_one, :player_one_id
    rename_column :games, :player_two, :player_two_id
  end
end
