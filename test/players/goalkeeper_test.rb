require 'test_helper'

module Rubygoal
  class GaolKeeperPlayerTest < Minitest::Test
    def setup
      home_coach = Coach.new(TestHomeCoachDefinition.new)
      away_coach = Coach.new(TestAwayCoachDefinition.new)
      @game = Game.new(home_coach, away_coach)

      @player = game.players.first
    end

    def test_goalkeeper_is_already_covering_goal
      goal_pos = Field.goal_position(:home)
      game.ball.position = Position.new(300, goal_pos.y)

      player.move_to_cover_goal(game.ball)
      player.update(elapsed_time)

      assert_equal Velocity.new(0, 0), player.velocity
    end

    def test_goalkeeper_moves_down_to_cover_goal
      game.ball.position = Position.new(300, 300)

      player.move_to_cover_goal(game.ball)
      player.update(elapsed_time)

      assert_in_delta Velocity.new(0, -3.5), player.velocity, 0.001
    end

    def test_goalkeeper_moves_up_to_cover_goal
      game.ball.position = Position.new(300, 900)

      player.move_to_cover_goal(game.ball)
      player.update(elapsed_time)

      assert_in_delta Velocity.new(0, 3.5), player.velocity, 0.001
    end

    private

    attr_reader :game, :player

    def elapsed_time
      1 / 60.0
    end
  end
end
