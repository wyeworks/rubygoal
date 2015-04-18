require 'rubygoal/coordinate'
require 'rubygoal/moveable'
require 'rubygoal/configuration'
require 'rubygoal/util'

module Rubygoal
  class Player
    STRAIGHT_ANGLE = 180

    include Moveable

    attr_reader :side, :type

    def initialize(side)
      super()

      @time_to_kick_again = 0
      @side = side
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

    def update(obstacles)
      update_waiting_to_kick!

      if moving?
        next_position = position.add(velocity)
        blocking = obstacles.select do |obs|
          obs != self && obs.position.distance(next_position) < 50 &&
            next_position.distance(destination) > destination.distance(obs.position)
        end

        if blocking.any?
          if position.distance(destination) < 60 || blocking.any?(&:moving?)
            stop
          else
            vel_angle = Util.angle(0, 0, velocity.x, velocity.y) - 90
            vel_magnitude = Util.distance(0, 0, velocity.x, velocity.y)
            self.velocity = Velocity.new(
              Util.offset_x(vel_angle, vel_magnitude),
              Util.offset_y(vel_angle, vel_magnitude),
            )
            #super()
          end
        end
      end

      super()
    end

    protected

    attr_accessor :time_to_kick_again

    private

    attr_reader :error

    def waiting_to_kick_again?
      time_to_kick_again > 0
    end

    def reset_waiting_to_kick!
      self.time_to_kick_again = Rubygoal.configuration.kick_again_delay
    end

    def update_waiting_to_kick!
      # TODO Make it time-based rather than counting ticks
      self.time_to_kick_again -= 1 if waiting_to_kick_again?
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
