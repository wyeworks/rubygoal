require 'test_helper'
require 'timecop'

module Rubygoal
  class GameTest < Minitest::Test
    def setup
      @game = Game.new
    end

    def test_initial_score
      assert_equal 0, @game.score_home
      assert_equal 0, @game.score_away
    end

    def test_score_after_home_team_goal
      goal_position = Field::goal_position(:away).add(Position.new(1, 0))
      @game.ball.position = goal_position

      @game.update

      assert_equal 1, @game.score_home
    end

    def test_score_after_away_team_goal
      goal_position = Field::goal_position(:home).add(Position.new(-1, 0))
      @game.ball.position = goal_position

      @game.update

      assert_equal 1, @game.score_away
    end

    def test_celebrating_goal_after_init
      refute @game.celebrating_goal?
    end

    def test_celebrating_goal_after_away_team_goal
      goal_position = Field::goal_position(:home).add(Position.new(-1, 0))
      @game.ball.position = goal_position

      @game.update

      assert @game.celebrating_goal?
    end

    def test_initial_time
      assert_equal Rubygoal.configuration.game_time, @game.time
    end

    def test_time_pass
      # Begin game with an initial update call
      @game.update

      # Simulate time passing
      elapsed_time = 70
      Timecop.travel(Time.now + elapsed_time)

      @game.update

      remaining_time = Rubygoal.configuration.game_time - elapsed_time
      assert_in_delta remaining_time, @game.time, 0.05
    end

    def test_players
      assert_equal 22, @game.players.size
    end
  end
end
