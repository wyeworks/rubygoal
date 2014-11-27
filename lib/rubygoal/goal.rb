require 'gosu'

require 'rubygoal/configuration'

module Rubygoal
  class Goal
    CELEBRATION_IMAGE_POSITION = Position.new(680, 466)

    def initialize(game, window)
      image_path = File.dirname(__FILE__) + '/../../media/goal.png'
      @image = Gosu::Image.new(window, image_path, true)

      @celebration_time = 0
    end

    def celebration_done?
      !celebrating?
    end

    def draw
      position = CELEBRATION_IMAGE_POSITION
      image.draw(position.x, position.y, 1)
    end

    def update(elapsed_time)
      start_celebration unless celebrating?
      self.celebration_time -= elapsed_time
    end

    protected

    attr_accessor :celebration_time

    private

    attr_reader :image

    def start_celebration
      self.celebration_time = 3
    end

    def celebrating?
      celebration_time > 0
    end
  end
end
