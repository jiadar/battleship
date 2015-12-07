class AddPlacedColumnToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :placed, :boolean, :default => false
  end
end
