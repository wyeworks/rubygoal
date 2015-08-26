require 'rubygoal/game'

module Rubygoal
  class Recorder
    def initialize(game)
      @game   = game
      @frames = []
    end

    def update
      @frames << record_frame
    end

    def to_hash
      {
        teams: {
          home: @game.coach_home.name,
          away: @game.coach_away.name
        },
        frames: @frames
      }
    end

    private

    attr_reader :game, :frames

    def record_frame
      {
        time: @game.time,
        score: { home: @game.score_home, away: @game.score_away },
        ball: {
          x: @game.ball.position.x,
          y: @game.ball.position.y
        }
      }
    end
  end
end
