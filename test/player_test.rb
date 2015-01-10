require 'test_helper'
require 'fixtures/four_fast_players_coach'
require 'fixtures/less_players_coach'
require 'fixtures/more_players_coach'
require 'fixtures/two_captains_coach'
require 'fixtures/valid_coach'

module Rubygoal
  class PlayerTest < Minitest::Test
    def setup
      @game = Game.new
      home_team = @game.team_home

      @player = home_team.players.values.first
      @player.send(:time_to_kick_again=, 0)
    end

    def test_player_can_kick_the_ball_in_the_same_position
      position = Position.new(100, 100)
      @game.ball.position = position
      @player.position = position

      assert @player.can_kick?(@game.ball)
    end

    def test_player_can_kick_the_ball_when_is_close
      @game.ball.position = Position.new(100, 100)
      @player.position = Position.new(110, 115)

      assert @player.can_kick?(@game.ball)
    end

    def test_player_can_not_kick_the_ball_when_is_far
      @game.ball.position = Position.new(100, 100)
      @player.position = Position.new(200, 200)

      refute @player.can_kick?(@game.ball)
    end

    def test_player_can_not_kick_the_ball_again
      position = Position.new(100, 100)
      @game.ball.position = position
      @player.position = position

      @player.kick(@game.ball, Position.new(300, 300))

      refute @player.can_kick?(@game.ball)
    end

    def test_player_can_kick_the_ball_again_after_time
      position = Position.new(100, 100)
      @game.ball.position = position
      @player.position = position

      @player.kick(@game.ball, Position.new(300, 300))
      ticks = Rubygoal.configuration.kick_again_delay
      ticks.times { @player.update }

      assert @player.can_kick?(@game.ball)
    end

    def test_kick_the_ball_to_a_different_place
      position = Position.new(100, 100)
      @game.ball.position = position
      @game.ball.velocity = Velocity.new(0, 0)
      @player.position = position

      @player.kick(@game.ball, Position.new(300, 300))

      refute_equal Velocity.new(0, 0), @game.ball.velocity
    end

    def test_kick_direction_range_right
      # Set little error: < 2 degrees (180 * 0.01 < 2)
      @player.instance_variable_set(:@error, 0.01)

      position = Position.new(100, 100)
      @game.ball.position = position
      @game.ball.velocity = Velocity.new(0, 0)
      @player.position = position

      # 0 degree kick
      @player.kick(@game.ball, Position.new(200, 100))

      velocity = @game.ball.velocity
      velocity_angle = Util.angle(0, 0, velocity.x, velocity.y)

      assert_in_delta 0, velocity_angle, 2
    end

    def test_kick_direction_range_left
      # Set little error: < 2 degrees (180 * 0.01 < 2)
      @player.instance_variable_set(:@error, 0.01)

      position = Position.new(100, 100)
      @game.ball.position = position
      @game.ball.velocity = Velocity.new(0, 0)
      @player.position = position

      # 180 degree kick
      @player.kick(@game.ball, Position.new(0, 100))

      velocity = @game.ball.velocity
      velocity_angle = Util.positive_angle(0, 0, velocity.x, velocity.y)

      assert_in_delta 180, velocity_angle, 2
    end

    def test_kick_strength
      # Set little error: distance error = 1 (20 * 0.05 = 1)
      @player.instance_variable_set(:@error, 0.05)

      position = Position.new(100, 100)
      @game.ball.position = position
      @game.ball.velocity = Velocity.new(0, 0)
      @player.position = position

      @player.kick(@game.ball, Position.new(200, 200))

      velocity = @game.ball.velocity
      velocity_strength = Util.distance(0, 0, velocity.x, velocity.y)

      assert_in_delta 20, velocity_strength, 1
    end

    def test_valid_players
      coach = ValidCoach.new
      assert coach.valid_formation?
      assert_empty coach.players_errors
    end

    def test_less_players
      coach = LessPlayersCoach.new
      assert !coach.valid_formation?
      expected = {average: 'The number of average players is 5'}
      assert_equal expected, coach.players_errors
    end

    def test_more_players
      coach = MorePlayersCoach.new
      expected = {average: 'The number of average players is 7'}
      assert !coach.valid_formation?
      assert_equal expected, coach.players_errors
    end

    def test_more_than_one_captain
      coach = TwoCaptainsCoach.new
      expected = {captain: 'The number of captains is 2', average: 'The number of average players is 5'}
      assert !coach.valid_formation?
      assert_equal expected, coach.players_errors
    end

    def test_more_than_three_fast
      coach = FourFastPlayersCoach.new
      expected = {fast: 'The number of fast players is 4', average: 'The number of average players is 5'}
      assert !coach.valid_formation?
      assert_equal expected, coach.players_errors
    end
  end
end
