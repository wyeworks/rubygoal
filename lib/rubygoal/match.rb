module Rubygoal
  class Match
    class Team
      attr_reader :score, :result, :positions

      def initialize(score, result, positions = nil)
        @score  = score
        @result = result
        @positions = positions

        convert_positions_to_percentages
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

      private

      def convert_positions_to_percentages
        @positions = positions.each_with_object({}) do |(name, pos), hash|
          hash[name] = Position.new(
            pos.x / Field::WIDTH * 100.0,
            pos.y / Field::HEIGHT * 100.0,
          )
        end
      end
    end

    attr_reader :me, :other, :time

    def self.create_for(side, time, score_home, score_away, positions_home, positions_away)
      case side
      when :home
        my_score = score_home
        other_score = score_away
        my_positions = positions_home
        other_positions = positions_away
      when :away
        my_score = score_away
        other_score = score_home
        my_positions = positions_away
        other_positions = positions_home
      end

      Match.new(my_score, other_score, my_positions, other_positions, time)
    end

    def initialize(my_score, other_score, my_positions, other_positions, time)
      @me = Match::Team.new(
        my_score,
        result(my_score, other_score),
        my_positions
      )
      @other = Match::Team.new(
        other_score,
        result(other_score, my_score),
        other_positions
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
