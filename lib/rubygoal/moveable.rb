require 'gosu'

require 'rubygoal/coordinate'

module Rubygoal
  module Moveable
    MIN_DISTANCE = 10

    attr_accessor :position, :velocity

    def initialize
      @position = Position.new(0, 0)
      @velocity = Velocity.new(0, 0)
      @speed = 0
      @destination = nil
    end

    def moving?
      velocity.nonzero?
    end

    def distance(position)
      Gosu.distance(self.position.x, self.position.y, position.x, position.y)
    end

    def move_to(destination)
      self.destination = destination

      angle = Gosu.angle(position.x, position.y, destination.x, destination.y)
      velocity.x = Gosu.offset_x(angle, speed)
      velocity.y = Gosu.offset_y(angle, speed)
    end

    def update
      return unless moving?

      if destination && distance(destination) < MIN_DISTANCE
        stop
      else
        position.x += velocity.x
        position.y += velocity.y
      end
    end

    private

    attr_reader :speed
    attr_accessor :destination

    def stop
      self.destination = nil
      self.velocity = Velocity.new(0, 0)
    end
  end
end
