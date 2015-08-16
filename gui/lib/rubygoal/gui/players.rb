require 'gosu'
require 'forwardable'

require 'rubygoal/util'

module Rubygoal::Gui
  class Players
    extend Forwardable
    def_delegators :player, :type, :side, :position, :destination, :rotation, :moving?

    def initialize(window, player)
      @player = player
      @image = Gosu::Image.new(window, image_filename, false)
    end

    def draw
      image.draw_rot(position.x, position.y, 1, rotation - 180)
    end

    private

    def image_filename
      File.dirname(__FILE__) + "/../../../media/#{type}_#{side}.png"
    end

    attr_reader :player, :image
  end
end
