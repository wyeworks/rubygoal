require 'test_helper'

require 'rubygoal/formation'

module Rubygoal
  class TestFormation < Minitest::Test
    def setup
      @formation = Formation.new
      @formation.lineup do
        defenders :average1, :average2, :none, :average3, :average4
        midfielders :average5, :fast1, :none, :fast2, :average6
        attackers :none, :captain, :none, :fast3, :none
      end
    end

    def test_default_formation_is_valid
      assert @formation.valid?
      assert_empty @formation.errors
    end

    def test_player_default_positions
      expected_positions = {
        average1: Position.new(232, 156),
        average2: Position.new(232, 312),
        average3: Position.new(232, 624),
        average4: Position.new(232, 780),
        average5: Position.new(697, 156),
        average6: Position.new(697, 780),
        captain: Position.new(1160, 312),
        fast1: Position.new(697, 312),
        fast2: Position.new(697, 624),
        fast3: Position.new(1160, 624)
      }

      assert_equal expected_positions, @formation.players_position
    end

    def test_custom_default_positions
      @formation.lineup do
        lines do
          defenders 180
          midfielders 600
          attackers 900
        end

        defenders :average1, :average2, :none, :average3, :average4
        midfielders :none, :fast1, :none, :fast2, :average6
        attackers :none, :captain, :none, :none, :none

        custom_position do
          player :fast3
          position 400, 100
        end
        custom_position do
          player :average5
          position 800, field_height / 2
        end
      end

      expected_positions = {
        average1: Position.new(180, 156),
        average2: Position.new(180, 312),
        average3: Position.new(180, 624),
        average4: Position.new(180, 780),
        average6: Position.new(600, 780),
        captain: Position.new(900, 312),
        fast1: Position.new(600, 312),
        fast2: Position.new(600, 624),

        fast3: Position.new(400, 100),
        average5: Position.new(800, 469)
      }

      assert_equal expected_positions, @formation.players_position
    end
  end
end
