module Rubygoal
  class Match
    class Team
      attr_reader :score, :result, :formation

      def initialize(score, result, other_formation = nil)
        @score     = score
        @result    = result
        @formation = other_formation
      end

      def draw?
        result == :draw
      end

      def winning?
        result == :win
      end

      def losing?
        result == :lose
      end
    end

    attr_reader :me, :other, :time

    def self.create_for(side, time, score_home, score_away,
                        formation_home, formation_away)
      case side
      when :home
        my_score    = score_home
        other_score = score_away
        formation   = formation_away
      when :away
        my_score    = score_away
        other_score = score_home
        formation   = formation_home
      end

      Match.new(my_score, other_score, time, formation)
    end

    def initialize(my_score, other_score, time, other_formation)
      @me = Match::Team.new(
        my_score,
        result(my_score, other_score)
      )
      @other = Match::Team.new(
        other_score,
        result(other_score, my_score),
        other_formation
      )
      @time = time
    end

    private

    def result(my_score, other_score)
      if my_score > other_score
        :win
      elsif my_score < other_score
        :lose
      else
        :draw
      end
    end
  end
end
