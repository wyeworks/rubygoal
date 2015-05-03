require 'rubygoal/coordinate'
require 'rubygoal/moveable'
require 'rubygoal/configuration'
require 'rubygoal/util'
require 'rubygoal/players/player_movement'

module Rubygoal
  class Player
    STRAIGHT_ANGLE = 180

    include Moveable

    attr_reader :side, :type

    def initialize(game, side)
      super()

      @time_to_kick_again = 0
      @side = side
      @player_movement = PlayerMovement.new(game, self)
    end

    def can_kick?(ball)
      !waiting_to_kick_again? && control_ball?(ball)
    end

    def kick(ball, target)
      direction = random_direction(target)
      strength = random_strength

      ball.move(direction, strength)
      reset_waiting_to_kick!
    end

    def update(elapsed_time)
      update_waiting_to_kick(elapsed_time)
      player_movement.update(elapsed_time) if moving?

      super
    end

    protected

    attr_accessor :time_to_kick_again, :player_movement

    private

    attr_reader :error

    def waiting_to_kick_again?
      time_to_kick_again > 0
    end

    def reset_waiting_to_kick!
      self.time_to_kick_again = Rubygoal.configuration.kick_again_delay
    end

    def update_waiting_to_kick(time_elapsed)
      self.time_to_kick_again -= time_elapsed if waiting_to_kick_again?
    end

    def control_ball?(ball)
      distance(ball.position) < Rubygoal.configuration.distance_control_ball
    end

    def random_strength
      error_range = (1 - error)..(1 + error)
      error_coef = Random.rand(error_range)
      Rubygoal.configuration.kick_strength * error_coef
    end

    def random_direction(target)
      direction = Util.angle(position.x, position.y, target.x, target.y)

      max_angle_error = STRAIGHT_ANGLE * error
      angle_error_range = -max_angle_error..max_angle_error

      direction += Random.rand(angle_error_range)
    end
  end
end

require 'rubygoal/players/average'
require 'rubygoal/players/fast'
require 'rubygoal/players/captain'
