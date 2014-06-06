require 'gosu'

require 'rubygoal/coordinate'
require 'rubygoal/moveable'
require 'rubygoal/configuration'

module Rubygoal
  class Player
    include Moveable

    def initialize(game_window, side)
      super()

      @image = Gosu::Image.new(game_window, image_filename(side), false)
      @time_to_kick_again = 0
      @field = game_window.field
    end

    def can_kick?(ball)
      !waiting_to_kick_again? && control_ball?(ball)
    end

    def kick(ball, target)
      strength = Rubygoal.configuration.kick_strength * Random.rand(error_range)

      direction = Gosu.angle(position.x, position.y, target.x, target.y)
      direction *= Random.rand(error_range)

      velocity = Velocity.new(
        Gosu.offset_x(direction, strength),
        Gosu.offset_y(direction, strength)
      )
      ball.velocity = velocity

      reset_waiting_to_kick!
    end

    def update
      update_waiting_to_kick!
      super
    end

    def draw
      if moving?
        angle = Gosu.angle(position.x, position.y, destination.x, destination.y)
        angle -= 90
      else
        angle = 0.0
      end

      image.draw_rot(position.x, position.y, 1, angle)
    end

    protected

    attr_accessor :time_to_kick_again

    private

    attr_reader :field, :image, :error

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

    def error_range
      (1.0 - error) .. (1.0 + error)
    end
  end
end

require 'rubygoal/players/average'
require 'rubygoal/players/fast'
require 'rubygoal/players/captain'
