require 'timecop'
require 'json'
require 'rubygoal/game'

module Rubygoal
  class Simulator
    extend Forwardable
    def_delegators :game, :recorded_game

    def initialize
      Rubygoal.configuration.record_game = true
      @game = Rubygoal::Game.new(load_coach(:home), load_coach(:away))
    end

    def simulate
      time = Time.now

      while !game.ended? do
        game.update
        time += 1.0 / 60.0
        Timecop.travel(time)
      end
    end

    private

    attr_reader :game

    def load_coach(side)
      CoachLoader.new(side).coach
    end
  end
end
