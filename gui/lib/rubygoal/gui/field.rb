require 'gosu'

require 'rubygoal/gui/ball'
require 'rubygoal/gui/players'

module Rubygoal::Gui
  class Field
    def initialize(window)
      image_path = File.dirname(__FILE__) + '/../../../media/background.png'
      @background_image = Gosu::Image.new(window, image_path, true)
    end

    def draw
      background_image.draw(0, 0, 0);
    end

    private

    attr_reader :background_image
  end
end
