require 'test_helper'

module Rubygoal
  class TeamTest < Minitest::Test
    def setup
      game = Game.new
      @home_team = game.team_home
      @away_team = game.team_away
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

      assert_equal expected, players_positions(@home_team)
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

      assert_equal expected, players_positions(@away_team)
    end

    def test_home_goalkeeper_position
      goalkeeper = @home_team.players[:goalkeeper]

      assert_equal Position.new(312, 581), goalkeeper.position
    end

    def test_away_goalkeeper_position
      goalkeeper = @away_team.players[:goalkeeper]

      assert_equal Position.new(1606, 581), goalkeeper.position
    end

    private

    def players_positions(team)
      team.players_list.map(&:position)
    end
  end
end

