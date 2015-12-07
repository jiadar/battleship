# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  state           :string           default("waiting"), not null
#  player_one      :integer          not null
#  player_two      :integer
#  guid            :string           not null
#  current_turn_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Game < ActiveRecord::Base

  STATES = ["waiting", "placing", "playing", "completed"]

  before_create :create_guid

  validates :state, inclusion: { in: STATES }

  def add_second_player(id)
    if id == self.player_one
      return errors.add(:game, "Cannot add yourself to your own game")
    elsif self.state != "waiting"
      return errors.add(:state, "Cannot add player to a game in progress")
    elsif full?
      return errors.add(:full, "Cannot join a full game")
    end

    self.player_two = id
  end

  def advance_state
    case self.state
    when "waiting"
      self.state = "placing"
    when "placing"
      self.state = "playing"
    when "playing"
      self.state = "completed"
    when "completed"
      # do nothing
    end
  end

  private

  def create_guid
    self.guid = SecureRandom.hex(10)
  end

  def full?
    self.player_one && self.player_two
  end

end
