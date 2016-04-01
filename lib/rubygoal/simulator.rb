require 'rubygoal/game'

module Rubygoal
  class Simulator
    extend Forwardable
    def_delegators :game, :recorded_game, :team_names

    def initialize
      Rubygoal.configuration.record_game = true
      @game = Rubygoal::Game.new(load_coach(:home), load_coach(:away))
    end

    def simulate
      time = 1.0 / 20.0

      while !game.ended? do
        game.update(time)
      end
    end

    private

    attr_reader :game

    def load_coach(side)
      CoachLoader.new(side).coach
    end
  end
end
