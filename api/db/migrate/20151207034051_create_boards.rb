class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :user_id, null: false
      t.integer :game_id, null: false
      t.timestamps null: false
    end
  end
end
