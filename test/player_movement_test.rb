require 'test_helper'

module Rubygoal
  class PlayerMovementTest < Minitest::Test
    def setup
      game = Game.new
      home_team = game.team_home

      @player = home_team.players.values[0]
      @other_player = home_team.players.values[1]

      @player_movement = PlayerMovement.new(game, player)
    end

    def test_do_not_modify_velocity_if_not_blocker
      player.position = Position.new(100, 0)
      other_player.position = Position.new(170, 0)

      player.move_to(Position.new(500, 0))
      player_movement.update(elapsed_time)

      assert_equal Velocity.new(3.5, 0), player.velocity
    end

    def test_modify_velocity_if_there_is_a_blocker_very_close
      player.position = Position.new(100, 0)
      other_player.position = Position.new(149, 0)

      player.move_to(Position.new(500, 0))
      player_movement.update(elapsed_time)

      assert_in_delta Velocity.new(2.5, -2.5), player.velocity, 0.1
    end

    def test_decelerate_if_there_is_a_blocker_a_bit_close
      player.position = Position.new(100, 0)
      other_player.position = Position.new(169, 0)

      player.move_to(Position.new(500, 0))
      player_movement.update(elapsed_time)

      assert_in_delta Velocity.new(3.1, 0), player.velocity, 0.1
    end

    def test_stop_if_close_to_destination_and_there_is_blocker
      player.position = Position.new(100, 0)
      other_player.position = Position.new(149, 0)

      player.move_to(Position.new(160, 0))
      player_movement.update(elapsed_time)

      assert_equal Velocity.new(0, 0), player.velocity
    end

    def test_stop_if_blocker_is_ver_close_and_moving
      player.position = Position.new(100, 0)
      other_player.position = Position.new(150, 0)

      player.move_to(Position.new(500, 0))
      other_player.move_to(Position.new(150, 500))
      player_movement.update(elapsed_time)

      assert_equal Velocity.new(0, 0), player.velocity
    end

    private

    attr_reader :player_movement, :player, :other_player

    def elapsed_time
      1 / 60.0
    end
  end
end
