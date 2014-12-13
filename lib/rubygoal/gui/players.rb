require 'gosu'
require 'forwardable'

require 'rubygoal/util'

module Rubygoal::Gui
  class Players
    extend Forwardable
    def_delegators :player, :type, :side, :position, :destination, :angle, :moving?

    def initialize(window, player)
      @player = player
      @image = Gosu::Image.new(window, image_filename, false)
    end

    def draw
      if moving?
        angle = Rubygoal::Util.angle(position.x, position.y, destination.x, destination.y)
        angle -= 180
      else
        angle = 0.0
      end

      image.draw_rot(position.x, position.y, 1, angle)
    end

    private

    def image_filename
      File.dirname(__FILE__) + "/../../../media/#{type}_#{side}.png"
    end

    attr_reader :player, :image
  end
end
