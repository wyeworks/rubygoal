module Rubygoal
  class Formation
    attr_accessor :lineup

    def initialize
      @lineup = empty_lineup
    end

    def defenders
      column(0)
    end

    def midfielders
      column(2)
    end

    def attackers
      column(4)
    end

    def column(i)
      lineup.map { |row| row[i] }
    end

    def defenders=(f)
      assign_column(0, f)
    end

    def midfielders=(f)
      assign_column(2, f)
    end

    def attackers=(f)
      assign_column(4, f)
    end

    def assign_column(index, column)
      column.each_with_index do |player, row_index|
        lineup[row_index][index] = player
      end
    end

    def lineup_for_opponent(players)
      result = empty_lineup

      lineup.each_with_index do |line, i|
        line.each_with_index do |name, j|
          if name != :none
            case players[name]
            when CaptainPlayer
              result[i][j] = :captain
            when FastPlayer
              result[i][j] = :fast
            when AveragePlayer
              result[i][j] = :average
            end
          end
        end
      end

      result
    end

    def errors
      errors = []
      if lineup.flatten.uniq.size != 11
        errors << 'Incorrect number of players, are you missing a name?'
      end

      errors
    end

    def valid?
      errors.empty?
    end

    private

    def empty_lineup
      Array.new(5) { Array.new(5, :none) }
    end
  end
end
