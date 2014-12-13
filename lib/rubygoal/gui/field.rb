require 'gosu'

require 'rubygoal/gui/ball'
require 'rubygoal/gui/players'

module Rubygoal::Gui
  class Field
    def initialize(window, field)
      @field = field
      @gui_ball = Ball.new(window, field.ball)
      @gui_players = players.map { |p| Players.new(window, p) }

      image_path = File.dirname(__FILE__) + '/../../../media/background.png'
      @background_image = Gosu::Image.new(window, image_path, true)
    end

    def draw
      background_image.draw(0, 0, 0);
      gui_ball.draw
      gui_players.each(&:draw)
    end

    private

    def players
      field.team_home.players.values + field.team_away.players.values
    end

    attr_reader :field, :gui_ball, :gui_players, :background_image
  end
end
