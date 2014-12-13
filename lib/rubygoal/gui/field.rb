require 'gosu'

module Rubygoal::Gui
  class Field
    def initialize(window, field)
      @field = field

      image_path = File.dirname(__FILE__) + '/../../../media/background.png'
      @background_image = Gosu::Image.new(window, image_path, true)
    end

    def draw
      background_image.draw(0, 0, 0);
      field.ball.draw
      field.team_home.draw
      field.team_away.draw
    end

    private

    attr_reader :field, :background_image
  end
end
