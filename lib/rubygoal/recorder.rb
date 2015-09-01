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
        score: {
          home: @game.score_home,
          away: @game.score_away
        },
        frames: @frames
      }
    end

    private

    attr_reader :game, :frames

    def frame_info
      {
        time: @game.time.round(0),
        score: { home: @game.score_home, away: @game.score_away },
        ball: {
          x: @game.ball.position.x.round(0),
          y: @game.ball.position.y.round(0)
        },
        home_players: team_info(@game.team_home),
        away_players: team_info(@game.team_away)
      }
    end

    def team_info(team)
      team.players.map do |_, player|
        {
          x:     player.position.x.round(0),
          y:     player.position.y.round(0),
          angle: player.rotation.round(0),
          type:  player.type
        }
      end
    end
  end
end
