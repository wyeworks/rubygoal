require 'test_helper'

module Rubygoal
  class TeamTest < Minitest::Test
    def setup
      game = Game.new
      #game.reinitialize
      @home_team = game.team_home
      @away_team = game.team_away
    end

    def test_default_home_coach
      assert_instance_of CoachHome, @home_team.coach
    end

    def test_default_away_coach
      assert_instance_of CoachAway, @away_team.coach
    end

    def test_home_initial_player_positions
      expected = [
        Position.new(312, 581),
        Position.new(498, 218),
        Position.new(498, 398),
        Position.new(498, 758),
        Position.new(498, 938),
        Position.new(698, 218),
        Position.new(698, 398),
        Position.new(698, 758),
        Position.new(698, 938),
        Position.new(878, 548),
        Position.new(878, 608)
      ]

      players_positions = @home_team.players.values.map(&:position)

      assert_equal expected, players_positions
    end

    def test_away_initial_player_positions
      expected = [
        Position.new(1606, 581),
        Position.new(1420, 944),
        Position.new(1420, 764),
        Position.new(1420, 404),
        Position.new(1420, 224),
        Position.new(1220, 944),
        Position.new(1220, 764),
        Position.new(1220, 404),
        Position.new(1220, 224),
        Position.new(1040, 614),
        Position.new(1040, 554)
      ]

      players_positions = @away_team.players.values.map(&:position)

      assert_equal expected, players_positions
    end

    def test_home_goalkeeper_position
      goalkeeper = @home_team.players[:goalkeeper]

      assert_equal Position.new(312, 581), goalkeeper.position
    end

    def test_away_goalkeeper_position
      goalkeeper = @away_team.players[:goalkeeper]

      assert_equal Position.new(1606, 581), goalkeeper.position
    end

    def test_initial_lineup
      expected = [
        [:average1, :none, :average2, :none, :none   ],
        [:average3, :none, :fast1,    :none, :captain],
        [:none,    :none, :none,    :none, :none   ],
        [:average4, :none, :fast2,    :none, :fast3   ],
        [:average5, :none, :average6, :none, :none   ]
      ]

      assert_equal expected, @home_team.formation.lineup
      assert_equal expected, @away_team.formation.lineup
    end
  end
end

