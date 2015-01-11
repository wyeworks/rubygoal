require 'rubygoal/util'
require 'rubygoal/field'
require 'rubygoal/moveable'

module Rubygoal
  class Ball
    include Moveable

    def initialize
      super
      reinitialize_position
    end

    def goal?
      Field.goal?(position)
    end

    def move(direction, speed)
      self.velocity = Velocity.new(
        Util.offset_x(direction, speed),
        Util.offset_y(direction, speed)
      )
    end

    def reinitialize_position
      self.position = Field.center_position
    end

    def update
      super

      prevent_out_of_bounds
      decelerate
    end

    private

    def prevent_out_of_bounds
      if Field.out_of_bounds_width?(position)
        velocity.x *= -1
      end
      if Field.out_of_bounds_height?(position)
        velocity.y *= -1
      end
    end

    def decelerate
      velocity.x *= deceleration_coef
      velocity.y *= deceleration_coef
    end

    def deceleration_coef
      Rubygoal.configuration.deceleration_coef
    end
  end
end
