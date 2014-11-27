require 'gosu'

require 'rubygoal/coordinate'

module Rubygoal::Gui
  class Goal
    CELEBRATION_IMAGE_POSITION = Rubygoal::Position.new(680, 466)

    def initialize(window)
      image_path = File.dirname(__FILE__) + '/../../../media/goal.png'
      @image = Gosu::Image.new(window, image_path, true)
    end

    def draw
      position = CELEBRATION_IMAGE_POSITION
      image.draw(position.x, position.y, 1)
    end

    private

    attr_reader :image
  end
end
