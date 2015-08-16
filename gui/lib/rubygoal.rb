require 'rubygoal-core'
require 'rubygoal/gui/game'

module Rubygoal
  class << self
    def start
      game = Game.new(load_coach(:home), load_coach(:away))
      gui = Gui::Game.new(game)
      gui.show
    end

    private

    def load_coach(side)
      CoachLoader.new(side).coach
    end
  end
end
