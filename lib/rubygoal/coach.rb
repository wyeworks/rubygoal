module Rubygoal
  class Coach
    def players
      {
        captain: [:captain],
        fast: [:fast1, :fast2, :fast3],
        average: [:average1, :average2, :average3, :average4, :average5, :average6]
      }
    end

    def name
      raise NotImplementedError
    end

    def formation(match)
      raise NotImplementedError
    end

    def errors
      errors = []

      config = Rubygoal.configuration

      captain_count = players[:captain].uniq.size
      fast_count = players[:fast].uniq.size
      average_count = players[:average].uniq.size

      if captain_count != config.captain_players_count
        errors << "The number of captains is #{captain_count}"
      end
      if fast_count != config.fast_players_count
        errors << "The number of fast players is #{fast_count}"
      end
      if average_count != config.average_players_count
        errors << "The number of average players is #{average_count}"
      end

      errors
    end

    def valid?
      errors.empty?
    end
  end
end
