# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  state           :string           default("waiting"), not null
#  player_one_id   :integer          not null
#  player_two_id   :integer
#  guid            :string           not null
#  current_turn_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Game < ActiveRecord::Base

  STATES = ["waiting", "placing", "playing", "completed"]

  before_create :create_guid

  validates :state, inclusion: { in: STATES }

  belongs_to :player_one, class_name: 'User', foreign_key: 'player_one_id'
  belongs_to :player_two, class_name: 'User', foreign_key: 'player_two_id'

  def player_one_board
    Board.find_by_sql("SELECT * FROM boards WHERE game_id = #{self.id} AND user_id = #{self.player_one_id}").first
  end

  def player_two_board
    Board.find_by_sql("SELECT * FROM boards WHERE game_id = #{self.id} AND user_id = #{self.player_two_id}").first
  end

  def has_player?(id)
    self.player_one_id == id || self.player_two_id == id
  end

  def swap_turns!
    if self.current_turn_id == self.player_one_id
      self.current_turn_id = self.player_two_id
    else
      self.current_turn_id = self.player_one_id
    end
    self.save!
  end

  def handle_shot(shot)
    board = opponents_board(self.current_turn_id)
    board.place_shot_and_save!(shot)

    board.result_of_hit(shot)
  end

  def board_for(player)
    if self.player_one_id == player.id
      return player_one_board
    end
    player_two_board
  end

  def opponents_board(player_id)
    if self.player_one_id == player_id
      return player_two_board
    end
    player_one_board
  end

  def add_second_player(id)
    if id == self.player_one_id
      return errors.add(:game, "Cannot add yourself to your own game")
    elsif self.state != "waiting"
      return errors.add(:state, "Cannot add player to a game in progress")
    elsif full?
      return errors.add(:full, "Cannot join a full game")
    end

    self.player_two_id = id
  end

  def try_advance_state!
    case self.state
    when "waiting"
      self.state = "placing" if full?
    when "placing"
      self.state = "playing" if placed?
    when "playing"
      self.state = "completed" if game_over?
    when "completed"
      # do nothing
    end
    self.save!
  end

  def build_boards
    board_params = board_params_for(player_one)
    player_one.boards.create!(board_params)

    board_params = board_params_for(player_two)
    player_two.boards.create!(board_params)
  end

  private

  def create_guid
    self.guid = SecureRandom.hex(10)
  end

  def board_params_for(player)
    {
      game_id: self.id,
      user_id: player.id,
      grid: Array.new(10) { Array.new(10) {0} }
    }
  end

  def game_over?
    self.player_one_board.lost? || self.player_two_board.lost?
  end

  def placed?
    self.player_one_board.placed && self.player_two_board.placed
  end

  def full?
    self.player_one_id && self.player_two_id
  end

end
