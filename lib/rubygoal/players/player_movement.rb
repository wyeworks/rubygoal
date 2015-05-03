require 'rubygoal/player'

module Rubygoal
  class PlayerMovement
    PLAYERS_MIN_DISTANCE   = 50
    CLOSE_TO_DESTINATION   = 60
    PLAYERS_CLOSE_DISTANCE = 70

    attr_reader :game, :player

    extend Forwardable
    def_delegators :player, :position, :velocity, :destination

    def initialize(game, player)
      @game = game
      @player = player
    end

    def update
      if blocking_player
        if close_to_destination? || any_moving_and_very_close_player?
          player.stop
        elsif blocking_player_very_close?
          adapt_velocity_when_very_close
        elsif blocking_player_close?
          adapt_velocity_when_close
        end
      end
    end

    private

    def game_players_except_me
      game.players - [player]
    end

    def game_players_closer_to_destination
      game_players_except_me.select do |p|
        destination.distance(position_after_update) >
          destination.distance(p.position)
      end
    end

    def blocking_player
      game_players_closer_to_destination.min_by do |p|
        position_after_update.distance(p.position)
      end
    end

    def close_to_destination?
      position_after_update.distance(destination) < CLOSE_TO_DESTINATION
    end

    def blocking_player_very_close?
      blocking_player.distance(position) < PLAYERS_MIN_DISTANCE
    end

    def blocking_player_close?
      blocking_player.distance(position) < PLAYERS_CLOSE_DISTANCE
    end

    def any_moving_and_very_close_player?
      game_players_closer_to_destination.any? do |p|
        p.moving? && p.distance(position_after_update) < PLAYERS_MIN_DISTANCE
      end
    end

    def adapt_velocity_when_very_close
      vel_angle = Util.angle(0, 0, velocity.x, velocity.y) - 45
      vel_magnitude = Util.distance(0, 0, velocity.x, velocity.y)

      player.velocity = Velocity.new(
        Util.offset_x(vel_angle, vel_magnitude),
        Util.offset_y(vel_angle, vel_magnitude),
      )
    end

    def adapt_velocity_when_close
      distance_to_run =
        blocking_player.distance(position_after_update) - PLAYERS_MIN_DISTANCE

      close_range_distance = (PLAYERS_CLOSE_DISTANCE - PLAYERS_MIN_DISTANCE).to_f

      # We want to decelerate when close, but we do not want to
      # have velocity = 0, so we add 0.5 to still be in movement
      deceleration_coef = (distance_to_run * 0.5) / close_range_distance + 0.5

      player.velocity = Velocity.new(
        velocity.x * deceleration_coef,
        velocity.y * deceleration_coef
      )
    end

    def position_after_update
      position.add(velocity)
    end
  end
end
