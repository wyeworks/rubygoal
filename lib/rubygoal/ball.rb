require 'rubygoal/util'
require 'rubygoal/field'
require 'rubygoal/moveable'

module Rubygoal
  class Ball
    include Moveable

    attr_reader :last_kick

    def initialize
      super
      reinitialize_position
    end

    def goal?
      Field.goal?(position)
    end

    def move(direction, speed, kicker)
      self.velocity = Velocity.new(
        Util.offset_x(direction, speed),
        Util.offset_y(direction, speed)
      )
      @last_kick = kicker
    end

    def reinitialize_position
      self.position = Field.center_position
      @last_kick = nil
    end

    def update(elapsed_time)
      super

      prevent_out_of_bounds
      decelerate(elapsed_time)
    end

    private

    def prevent_out_of_bounds
      velocity.x *= -1 if Field.out_of_bounds_width?(position)
      velocity.y *= -1 if Field.out_of_bounds_height?(position)
    end

    def decelerate(elapsed_time)
      coef = deceleration_coef(elapsed_time)

      self.velocity = velocity.mult(coef)
    end

    def deceleration_coef(elapsed_time)
      custom_frame_rate = 1 / 60.0
      time_coef = elapsed_time / custom_frame_rate

      Rubygoal.configuration.deceleration_coef**time_coef
    end
  end
end
