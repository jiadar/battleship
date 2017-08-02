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

require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
