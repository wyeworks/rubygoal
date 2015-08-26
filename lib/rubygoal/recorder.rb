require 'rubygoal/game'

module Rubygoal
  class Recorder
    def initialize(game)
      @game   = game
      @frames = []
    end

    def update
      @frames << frame_info
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

    def frame_info
      {
        time: @game.time,
        score: { home: @game.score_home, away: @game.score_away },
        ball: {
          x: @game.ball.position.x,
          y: @game.ball.position.y
        },
        teams: teams_info
      }
    end

    def teams_info
      {
        home_player_positions:
          absolute_positions(@game.home_players_positions, :home),
        away_player_positions:
          absolute_positions(@game.away_players_positions, :away)
      }
    end

    def absolute_positions(player_positions, side)
      player_positions.values.map { |pos| Field.absolute_position(pos, side) }
    end
  end
end
