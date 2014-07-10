module Rubygoal
  class Coach
    def players
      raise NotImplementedError
    end

    def name
      raise NotImplementedError
    end

    def formation(match)
      raise NotImplementedError
    end

    def formation_errors
      errors = {}

      config = Rubygoal.configuration

      if players[:captain].uniq.size != config.captain_players_count
        errors[:captain] = "The number of captains is #{captain_count}"
      end
      if players[:fast].uniq.size != config.fast_players_count
        errors[:fast] = "The number of fast players is #{fast_count}"
      end
      if players[:average].uniq.size != config.average_players_count
        errors[:average] = "The number of average players is #{average_count}"
      end
      if formation.lineup.flatten.uniq.size != 11
        raise 'Incorrect number of players, are you missing a name?'
      end

      errors
    end

    def valid_formation?
      formation_errors.empty?
    end
  end
end
