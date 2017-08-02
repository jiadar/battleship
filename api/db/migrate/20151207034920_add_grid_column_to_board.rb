class AddGridColumnToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :grid, :text
  end
end
