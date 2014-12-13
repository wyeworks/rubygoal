require 'rubygoal/game'
require 'rubygoal/gui/game'

module Rubygoal
  def self.start
    game = Game.new
    gui = Gui::Game.new(game)
    gui.show
  end
end
