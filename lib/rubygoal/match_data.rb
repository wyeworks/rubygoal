module Rubygoal
  class MatchData
    class Factory
      extend Forwardable
      def_delegators :game, :ball_position, :score_home, :score_away, :time,
                     :home_players_positions, :away_players_positions

      def initialize(game, side)
        @game = game
        @side = side
      end

      def create
        MatchData.new(
          my_score,
          other_score,
          ball_match_position,
          my_positions,
          other_positions,
          time
        )
      end

      private

      attr_reader :game, :side

      def remove_goalkeeper_position(positions)
        positions.tap do |ps|
          ps.delete(:goalkeeper)
        end
      end

      def home_players_positions
        remove_goalkeeper_position(game.home_players_positions)
      end

      def away_players_positions
        remove_goalkeeper_position(game.away_players_positions)
      end

      def other_side
        side == :home ? :away : :home
      end

      def my_score
        send("score_#{side}")
      end

      def other_score
        send("score_#{other_side}")
      end

      def my_positions
        send("#{side}_players_positions")
      end

      def other_positions
        send("#{other_side}_players_positions")
      end

      def ball_field_position
        Field.field_position(ball_position, side)
      end

      def ball_match_position
        Field.position_to_percentages(ball_field_position)
      end
    end

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
          hash[name] = Field.position_to_percentages(pos)
        end
      end
    end

    attr_reader :me, :other, :time, :ball

    def initialize(my_score, other_score, ball_position, my_positions, other_positions, time)
      @me = MatchData::Team.new(
        my_score,
        result(my_score, other_score),
        my_positions
      )
      @other = MatchData::Team.new(
        other_score,
        result(other_score, my_score),
        other_positions
      )
      @time = time
      @ball = ball_position
    end

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
