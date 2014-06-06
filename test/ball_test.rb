require 'test_helper'

require 'rubygoal/ball'
require 'rubygoal/field'

module Rubygoal
  class BallTest < Minitest::Test
    def setup
      game = Rubygoal.game_instance
      @ball = Ball.new(game, Field.center_position)
    end

    def test_ball_is_in_home_goal_position
      @ball.position = Field.goal_position(:home).add(Position.new(-1, 0))

      assert @ball.goal?
    end

    def test_ball_is_in_away_goal_position
      @ball.position = Field.goal_position(:away).add(Position.new(1, 0))

      assert @ball.goal?
    end

    def test_ball_is_not_in_goal_position
      @ball.position = Field.goal_position(:home)

      assert !@ball.goal?
    end

    def test_ball_velocity_drops_by_095_on_each_update
      @ball.velocity = Velocity.new(10, 10)
      @ball.update
      @ball.update

      assert_equal Velocity.new(9.025, 9.025), @ball.velocity
      assert_equal Position.new(978.5, 600.5), @ball.position
    end

    def test_ball_bounces_on_the_height
      @ball.position = Position.new(265, 500)
      @ball.velocity = Velocity.new(-10, 10)
      @ball.update

      assert_equal Velocity.new(9.5, 9.5), @ball.velocity
      assert_equal Position.new(255, 510), @ball.position
    end
  end
end
