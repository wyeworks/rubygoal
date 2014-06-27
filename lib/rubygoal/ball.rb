require 'gosu'

require 'rubygoal/field'
require 'rubygoal/moveable'

module Rubygoal
  class Ball
    IMAGE_SIZE = 20

    include Moveable

    def initialize(window, position)
      super()

      @position = position

      image_path = File.dirname(__FILE__) + '/../../media/ball.png'
      @image = Gosu::Image.new(window, image_path, false)
    end

    def goal?
      Field.goal?(position)
    end

    def move(direction, speed)
      self.velocity = Velocity.new(
        Gosu.offset_x(direction, speed),
        Gosu.offset_y(direction, speed)
      )
    end

    def draw
      half_side_lenght = IMAGE_SIZE / 2
      image_center_x = position.x - half_side_lenght
      image_center_y = position.y - half_side_lenght

      image.draw(image_center_x, image_center_y, 1)
    end

    def update
      super
      if Field.out_of_bounds_width?(position)
        velocity.x *= -1
      end
      if Field.out_of_bounds_height?(position)
        velocity.y *= -1
      end

      velocity.x *= 0.95
      velocity.y *= 0.95
    end

    private

    attr_reader :image
  end
end
