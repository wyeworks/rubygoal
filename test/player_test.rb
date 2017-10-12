require 'test_helper'

module Rubygoal
  class PlayerTest < Minitest::Test
    def setup
      home_coach = Coach.new(TestHomeCoachDefinition.new)
      away_coach = Coach.new(TestAwayCoachDefinition.new)
      @game = Game.new(home_coach, away_coach)

      @player = game.players.first
      @player.send(:time_to_kick_again=, 0)
    end

    def test_player_can_kick_the_ball_in_the_same_position
      position = Position.new(100, 100)
      game.ball.position = position
      player.position = position

      assert player.can_kick?(game.ball)
    end

    def test_player_can_kick_the_ball_when_is_close
      game.ball.position = Position.new(100, 100)
      player.position = Position.new(110, 115)

      assert player.can_kick?(game.ball)
    end

    def test_player_can_not_kick_the_ball_when_is_far
      game.ball.position = Position.new(100, 100)
      player.position = Position.new(200, 200)

      refute player.can_kick?(game.ball)
    end

    def test_player_can_not_kick_the_ball_again
      position = Position.new(100, 100)
      game.ball.position = position
      player.position = position

      player.kick(game.ball, Position.new(300, 300))

      refute player.can_kick?(game.ball)
    end

    def test_player_can_kick_the_ball_again_after_time
      position = Position.new(100, 100)
      game.ball.position = position
      player.position = position

      player.kick(game.ball, Position.new(300, 300))
      player.update(Rubygoal.configuration.kick_again_delay)

      assert player.can_kick?(game.ball)
    end

    def test_kick_the_ball_to_a_different_place
      position = Position.new(100, 100)
      game.ball.position = position
      game.ball.velocity = Velocity.new(0, 0)
      player.position = position

      player.kick(game.ball, Position.new(300, 300))

      refute_equal Velocity.new(0, 0), game.ball.velocity
    end

    def test_kick_direction_range_right
      # Set little error: < 2 degrees (180 * 0.01 < 2)
      player.instance_variable_set(:@error, 0.01)

      position = Position.new(100, 100)
      game.ball.position = position
      game.ball.velocity = Velocity.new(0, 0)
      player.position = position

      # 0 degree kick
      player.kick(game.ball, Position.new(200, 100))

      velocity = game.ball.velocity
      velocity_angle = Util.angle(0, 0, velocity.x, velocity.y)

      assert_in_delta 0, velocity_angle, 2
    end

    def test_kick_direction_range_left
      # Set little error: < 2 degrees (180 * 0.01 < 2)
      player.instance_variable_set(:@error, 0.01)

      position = Position.new(100, 100)
      game.ball.position = position
      game.ball.velocity = Velocity.new(0, 0)
      player.position = position

      # 180 degree kick
      player.kick(game.ball, Position.new(0, 100))

      velocity = game.ball.velocity
      velocity_angle = Util.positive_angle(0, 0, velocity.x, velocity.y)

      assert_in_delta 180, velocity_angle, 2
    end

    def test_kick_strength
      # Set little error: distance error = 1 (20 * 0.05 = 1)
      player.instance_variable_set(:@error, 0.05)

      position = Position.new(100, 100)
      game.ball.position = position
      game.ball.velocity = Velocity.new(0, 0)
      player.position = position

      player.kick(game.ball, Position.new(200, 200))

      velocity = game.ball.velocity
      velocity_strength = Util.distance(0, 0, velocity.x, velocity.y)

      assert_in_delta 20, velocity_strength, 1
    end

    def test_kick_registered
      assert_nil game.ball.last_kick

      position = Position.new(100, 100)
      game.ball.position = position
      game.ball.velocity = Velocity.new(0, 0)
      player.position = position

      player.kick(game.ball, Position.new(300, 300))

      assert_equal player.name, game.ball.last_kick[:name]
      assert_equal player.side, game.ball.last_kick[:side]
    end

    private

    attr_reader :game, :player
  end
end
