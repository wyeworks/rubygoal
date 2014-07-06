module Rubygoal
  class Formation
    attr_accessor :lineup
    attr_reader :old_formation

    def initialize
      @lineup = [
        [:none, :none, :none, :none, :none],
        [:none, :none, :none, :none, :none],
        [:none, :none, :none, :none, :none],
        [:none, :none, :none, :none, :none],
        [:none, :none, :none, :none, :none],
      ]
      @old_formation = false
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

    def errors
      errors = {}

      unified        = lineup.flatten
      captain_count  = unified.count(:captain)
      fast_count    = unified.count(:fast1)
      fast_count    += unified.count(:fast2)
      fast_count    += unified.count(:fast3)
      average_count = unified.count(:average1)
      average_count += unified.count(:average2)
      average_count += unified.count(:average3)
      average_count += unified.count(:average4)
      average_count += unified.count(:average5)
      average_count += unified.count(:average6)

      if fast_count == 0 && average_count == 0
        fast_count = unified.count(:fast)
        average_count = unified.count(:average)
        @old_formation = true
      else
        @old_formation = false
      end

      config = Rubygoal.configuration

      if captain_count != config.captain_players_count
        errors[:captain] = "The number of captains is #{captain_count}"
      end
      if fast_count != config.fast_players_count
        errors[:fast] = "The number of fast players is #{fast_count}"
      end
      if average_count != config.average_players_count
        errors[:average] = "The number of average players is #{average_count}"
      end

      errors
    end

    def valid?
      errors.empty?
    end
  end
end
