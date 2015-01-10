require 'forwardable'

require 'rubygoal/coordinate'
require 'rubygoal/field'
require 'rubygoal/goal'

module Rubygoal
  class Game
    attr_reader :team_home, :team_away, :ball,
                :time, :goal,
                :coach_home, :coach_away,
                :score_home, :score_away

    def initialize
      initialize_coaches

      @ball = Ball.new

      @team_home = HomeTeam.new(self, coach_home)
      @team_away = AwayTeam.new(self, coach_away)

      @goal = Goal.new(self)

      @state = :playing

      @time = Rubygoal.configuration.game_time
      @score_home = 0
      @score_away = 0
    end

    def update
      return if state == :ended

      update_elapsed_time

      if celebrating_goal?
        update_goal
      else
        update_remaining_time
        team_home.update(game_data(:home))
        team_away.update(game_data(:away))
        update_ball
      end

      end_match! if time <= 0
    end

    def players
      # TODO improve this!
      teams.map { |t| t.players.values }.flatten
    end

    def celebrating_goal?
      goal.celebrating?
    end

    protected

    attr_writer :time, :score_home, :score_away
    attr_accessor :state, :last_time, :elapsed_time

    private

    attr_reader :font, :home_team_label, :away_team_label

    def initialize_coaches
      @coach_home = CoachLoader.get(CoachHome)
      @coach_away = CoachLoader.get(CoachAway)

      puts "Home coach: #{@coach_home.name}"
      puts "Away coach: #{@coach_away.name}"
    end

    def update_elapsed_time
      self.last_time ||= Time.now

      self.elapsed_time = Time.now - last_time
      self.last_time = Time.now
    end

    def update_remaining_time
      self.time -= elapsed_time
    end

    def update_ball
      ball.update
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
      if Field.position_side(ball.position) == :home
        self.score_away += 1
      else
        self.score_home += 1
      end
    end

    def reinitialize_players
      teams.map(&:players_to_initial_position)
    end

    def reinitialize_ball
      ball.position = Field.center_position
    end

    def teams
      [team_home, team_away]
    end

    # TODO think a better name
    def game_data(side)
      case side
      when :home
        Match.new(
          score_home,
          score_away,
          time,
          team_away.formation.formation_types(team_home.players)
        )
      when :away
        Match.new(
          score_away,
          score_home,
          time,
          team_home.formation.formation_types(team_home.players)
        )
      end
    end

    def end_match!
      self.state = :ended
      puts_score
    end

    def puts_score
      puts "#{coach_home.name} #{score_home} - #{score_away} #{coach_away.name}"
    end
  end
end
