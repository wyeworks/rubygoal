require 'rubygoal/util'
require 'rubygoal/coordinate'

module Rubygoal
  module Moveable
    MIN_DISTANCE = 10

    attr_accessor :position, :velocity, :rotation

    def initialize
      @position = Position.new(0, 0)
      @velocity = Velocity.new(0, 0)
      @speed = 0
      @destination = nil
      @rotation = 0
    end

    def moving?
      velocity.nonzero?
    end

    def distance(position)
      Util.distance(self.position.x, self.position.y, position.x, position.y)
    end

    def move_to(destination)
      self.destination = destination

      self.rotation = Util.angle(position.x, position.y, destination.x, destination.y)
      velocity.x = Util.offset_x(rotation, speed)
      velocity.y = Util.offset_y(rotation, speed)
    end

    def update(elapsed_time)
      return unless moving?

      if destination && distance(destination) < MIN_DISTANCE
        stop
        reset_rotation
      else
        self.position = position_after_update(elapsed_time)
      end
    end

    def stop
      self.destination = nil
      self.velocity = Velocity.new(0, 0)
    end

    def position_after_update(elapsed_time)
      custom_frame_rate = 1 / 60.0
      coef = elapsed_time / custom_frame_rate
      movement = velocity.mult(coef)

      position.add(movement)
    end

    attr_accessor :destination

    private

    attr_reader :speed

    def reset_rotation
      self.rotation = 0
    end
  end
end
