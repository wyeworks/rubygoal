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
        average3: Position.new(232, 625),
        average4: Position.new(232, 782),
        average5: Position.new(697, 156),
        average6: Position.new(697, 782),
        captain: Position.new(1162, 312),
        fast1: Position.new(697, 312),
        fast2: Position.new(697, 625),
        fast3: Position.new(1162, 625)
      }

      expected_positions.each do |name, pos|
        assert_in_delta pos, @formation.players_position[name], 1
      end
    end

    def test_custom_default_positions
      @formation.lineup do
        lines do
          defenders 13
          midfielders 43
          attackers 65
        end

        defenders :average1, :average2, :none, :average3, :average4
        midfielders :none, :fast1, :none, :fast2, :average6
        attackers :none, :captain, :none, :none, :none

        custom_position do
          player :fast3
          position 30, 10
        end
        custom_position do
          player :average5
          position 60, 50
        end
      end

      expected_positions = {
        average1: Position.new(181, 156),
        average2: Position.new(181, 312),
        average3: Position.new(181, 625),
        average4: Position.new(181, 781),
        average6: Position.new(600, 781),
        captain: Position.new(906, 312),
        fast1: Position.new(600, 312),
        fast2: Position.new(600, 625),

        fast3: Position.new(418, 94),
        average5: Position.new(836, 469)
      }

      expected_positions.each do |name, pos|
        assert_in_delta pos, @formation.players_position[name], 1
      end
    end
  end
end
