require 'forwardable'

require 'rubygoal/coordinate'
require 'rubygoal/field'
require 'rubygoal/goal'

module Rubygoal
  class Game
    attr_reader :field, :time, :goal,
                :coach_home, :coach_away,
                :score_home, :score_away

    extend Forwardable
    def_delegators :field, :ball, :close_to_goal?

    def initialize(window)
      initialize_coaches

      @field = Field.new(self, window, coach_home, coach_away)
      @goal = Goal.new(self, window)

      @state = :playing

      @time = Rubygoal.configuration.game_time
      @score_home = 0
      @score_away = 0
    end

    def update
      return if state == :ended

      update_elapsed_time

      if field.goal?
        update_goal
      else
        update_remaining_time
        field.update
      end

      end_match! if time <= 0
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

    def update_goal
      goal.update(elapsed_time)
      reinitialize_match if goal.celebration_done?
    end

    def reinitialize_match
      if Field.position_side(ball.position) == :home
        self.score_away += 1
      else
        self.score_home += 1
      end

      field.reinitialize
    end

    def end_match!
      self.state = :ended
      write_score
    end

    def write_score
      puts "#{coach_home.name} #{score_home} - #{score_away} #{coach_away.name}"
    end
  end
end
