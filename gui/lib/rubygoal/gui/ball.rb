require 'gosu'

module Rubygoal::Gui
  class Ball
    IMAGE_SIZE = 20

    def initialize(window, ball)
      @ball = ball

      image_path = File.dirname(__FILE__) + '/../../../media/ball.png'
      @image = Gosu::Image.new(window, image_path, false)
    end

    def draw
      half_side_lenght = IMAGE_SIZE / 2
      image_center_x = ball.position.x - half_side_lenght
      image_center_y = ball.position.y - half_side_lenght

      image.draw(image_center_x, image_center_y, 1)
    end

    private

    attr_reader :ball, :image
  end
end
