require 'test_helper'

module Rubygoal
  class TeamTest < Minitest::Test
    def setup
      game = Game.new
      @home_team = game.team_home
      @away_team = game.team_away
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

