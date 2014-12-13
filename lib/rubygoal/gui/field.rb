require 'gosu'

require 'rubygoal/gui/ball'

module Rubygoal::Gui
  class Field
    def initialize(window, field)
      @field = field
      @ball = Ball.new(window, field.ball)

      image_path = File.dirname(__FILE__) + '/../../../media/background.png'
      @background_image = Gosu::Image.new(window, image_path, true)
    end

    def draw
      background_image.draw(0, 0, 0);
      ball.draw
      field.team_home.draw
      field.team_away.draw
    end

    private

    attr_reader :field, :ball, :background_image
  end
end
