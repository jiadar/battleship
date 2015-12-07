# == Schema Information
#
# Table name: boards
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  game_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  grid       :text
#  placed     :boolean          default(FALSE)
#

class Board < ActiveRecord::Base
  serialize :grid

  belongs_to :game, class_name: 'Game', foreign_key: 'game_id'
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  def place_ships(ships)
    if ships_are_valid?(ships)
      ships.each do |ship|
        ship['ship'].each do |coords|
          x, y = coords['coord'][0], coords['coord'][1]
          self.grid[y][x] = ship['ship'].length
        end
      end

      self.placed = true
      self.save!
    else
      errors.add(:placement, "Invalid ship placement")
    end
  end

  def lost?
    self.grid.each do |row|
      row.each do |cell|
        return false if cell.between?(1,5)
      end
    end

    true
  end

  def place_shot_and_save!(shot)
    x, y = shot[0], shot[1]
    self.grid[y][x] = -1
    self.save!
  end

  def result_of_hit(shot)
    x, y = shot[0], shot[1]
    element = self.grid[y][x]
    
    case element
    when element.between?(1,5)
      return "Hit at #{x}, #{y}"
    when -1
      return "Already targeted #{x}, #{y}"
    else
      return "Miss at #{x}, #{y}"
    end
  end

  private

  def ships_are_valid?(ships)
    ships.each do |ship|
      ship['ship'].each do |coords|
        x, y = coords['coord'][0], coords['coord'][1]
        if !x.between?(0, 10) || !y.between?(0, 10)
          return false
        end
      end
    end
    true
  end

end
