require 'test_helper'
require 'fixtures/mirror_strategy_coach_definition'

module Rubygoal
  class TeamTest < Minitest::Test
    def setup
      home_coach = Coach.new(TestHomeCoachDefinition.new)
      away_coach = Coach.new(TestAwayCoachDefinition.new)
      game = Game.new(home_coach, away_coach)

      @home_team = game.team_home
      @away_team = game.team_away
    end

    def test_home_team_initial_positions_are_in_own_field
      expected_positions = {
        home_average1: Position.new(232 / 2, 156),
        home_average2: Position.new(697 / 2, 156),
        home_average3: Position.new(1162 / 2, 312),
        home_average4: Position.new(1162 / 2, 625),
        home_average5: Position.new(232 / 2, 782),
        home_average6: Position.new(697 / 2, 782),
        home_fast1: Position.new(232 / 2, 312),
        home_fast2: Position.new(1162 / 2, 469),
        home_fast3: Position.new(232 / 2, 625),
        home_captain: Position.new(697 / 2, 469)
      }

      expected_positions.each do |name, pos|
        assert_in_delta pos, @home_team.players_position[name], 1
      end
    end

    def test_away_team_initial_positions_are_in_own_field
      expected_positions = {
        away_average1: Position.new(232 / 2, 156),
        away_average2: Position.new(697 / 2, 156),
        away_average3: Position.new(697 / 2, 312),
        away_average4: Position.new(697 / 2, 625),
        away_average5: Position.new(232 / 2, 782),
        away_average6: Position.new(697 / 2, 782),
        away_fast1: Position.new(232 / 2, 312),
        away_fast2: Position.new(1162 / 2, 469),
        away_fast3: Position.new(232 / 2, 625),
        away_captain: Position.new(697 / 2, 469)
      }

      expected_positions.each do |name, pos|
        assert_in_delta pos, @away_team.players_position[name], 1
      end
    end

    def test_default_opponent_positions_for_initial_positions
      home_coach = Coach.new(MirrorStrategyCoachDefinition.new)
      away_coach = Coach.new(TestAwayCoachDefinition.new)
      game = Game.new(home_coach, away_coach)

      home_team = game.team_home

      expected_positions = {
        average1: Position.new(232 / 2, 750),
        average2: Position.new(232 / 2, 563),
        average3: Position.new(232 / 2, 375),
        average4: Position.new(232 / 2, 187),
        average5: Position.new(697 / 2, 750),
        average6: Position.new(697 / 2, 563),
        fast1: Position.new(697 / 2, 375),
        fast2: Position.new(697 / 2, 187),
        fast3: Position.new(1162 / 2, 625),
        captain: Position.new(1162 / 2, 312)
      }

      expected_positions.each do |name, pos|
        assert_in_delta pos, home_team.players_position[name], 1
      end
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

