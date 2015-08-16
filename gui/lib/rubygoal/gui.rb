require 'rubygoal'
require 'rubygoal/gui/game'

module Rubygoal
  module Gui
    class << self
      def start
        game = Rubygoal::Game.new(load_coach(:home), load_coach(:away))
        gui = Game.new(game)
        gui.show
      end

      private

      def load_coach(side)
        CoachLoader.new(side).coach
      end
    end
  end
end
