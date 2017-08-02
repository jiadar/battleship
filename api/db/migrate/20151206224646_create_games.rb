class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :state, null: false, default: :waiting
      t.integer :player_one, null: false
      t.integer :player_two
      t.string :guid, null: false
      t.integer :current_turn_id, null: false
      t.timestamps null: false
    end
  end
end
