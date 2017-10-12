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
        score: [@game.score_home, @game.score_away],
        frames: @frames
      }
    end

    private

    attr_reader :game, :frames

    def frame_info
      frame = {
        time: @game.time.round(0),
        score: [@game.score_home, @game.score_away],
        ball: [
          @game.ball.position.x.round(0),
          @game.ball.position.y.round(0)
        ],
        home: team_info(@game.team_home),
        away: team_info(@game.team_away)
      }
      last_kick_info(frame) if Rubygoal.configuration.record_last_kick

      frame
    end

    def team_info(team)
      team.players.map do |_, player|
        [
          player.position.x.round(0),
          player.position.y.round(0),
          player.rotation.round(0),
          player.type[0]
        ]
      end
    end

    def last_kick_info(frame)
      if @game.ball.last_kick
        frame[:last_kick] = [
          @game.ball.last_kick[:name],
          @game.ball.last_kick[:side]
        ]
      end
    end
  end
end
