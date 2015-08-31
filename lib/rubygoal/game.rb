require 'forwardable'

require 'rubygoal/coordinate'
require 'rubygoal/field'
require 'rubygoal/goal'
require 'rubygoal/recorder'

module Rubygoal
  class Game
    attr_reader :team_home, :team_away, :ball,
                :time, :goal, :recorder,
                :coach_home, :coach_away,
                :score_home, :score_away

    def initialize(coach_home, coach_away)
      @coach_home = coach_home
      @coach_away = coach_away

      if debug_output?
        puts "Home coach: #{@coach_home.name}"
        puts "Away coach: #{@coach_away.name}"
      end

      @recorder = Recorder.new(self) if record_game?

      @ball = Ball.new

      @team_home = HomeTeam.new(self, coach_home)
      @team_away = AwayTeam.new(self, coach_away)

      @goal = Goal.new

      @state = :playing

      @time = Rubygoal.configuration.game_time
      @score_home = 0
      @score_away = 0

      reinitialize_players
    end

    def update
      return if ended?

      update_elapsed_time

      if celebrating_goal?
        update_goal
      else
        update_remaining_time
        team_home.update(elapsed_time)
        team_away.update(elapsed_time)
        update_ball
      end

      recorder.update if record_game?

      end_match! if time <= 0
    end

    def players
      teams.map(&:players_list).flatten
    end

    def celebrating_goal?
      goal.celebrating?
    end

    def home_players_positions
      team_home.players_position
    end

    def away_players_positions
      team_away.players_position
    end

    def ball_position
      ball.position
    end

    def recorded_game
      recorder.to_hash if record_game?
    end

    def ended?
      state == :ended
    end

    protected

    attr_writer :time, :score_home, :score_away
    attr_accessor :state, :last_time, :elapsed_time

    private

    def update_elapsed_time
      self.last_time ||= Time.now

      self.elapsed_time = Time.now - last_time
      self.last_time = Time.now
    end

    def update_remaining_time
      self.time -= elapsed_time
    end

    def update_ball
      ball.update(elapsed_time)
      if ball.goal?
        update_score
        goal.start_celebration
      end
    end

    def update_goal
      goal.update(elapsed_time)
      reinitialize_match unless goal.celebrating?
    end

    def reinitialize_match
      reinitialize_players
      reinitialize_ball
    end

    def update_score
      if Field.position_side(ball_position) == :home
        self.score_away += 1
      else
        self.score_home += 1
      end
    end

    def reinitialize_players
      teams.each(&:players_to_initial_position)
    end

    def reinitialize_ball
      ball.position = Field.center_position
    end

    def teams
      [team_home, team_away]
    end

    def end_match!
      self.state = :ended
      puts_score if debug_output?
    end

    def puts_score
      puts "#{coach_home.name} #{score_home} - #{score_away} #{coach_away.name}"
    end

    def debug_output?
      Rubygoal.configuration.debug_output
    end

    def record_game?
      Rubygoal.configuration.record_game
    end
  end
end
