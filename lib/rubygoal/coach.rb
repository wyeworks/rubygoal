module Rubygoal
  class Coach
    PlayerDefinition = Struct.new(:name, :type)

    def players
      [
        PlayerDefinition.new(:captain, :captain),
        PlayerDefinition.new(:fast1, :fast),
        PlayerDefinition.new(:fast2, :fast),
        PlayerDefinition.new(:fast3, :fast),
        PlayerDefinition.new(:average1, :average),
        PlayerDefinition.new(:average2, :average),
        PlayerDefinition.new(:average3, :average),
        PlayerDefinition.new(:average4, :average),
        PlayerDefinition.new(:average5, :average),
        PlayerDefinition.new(:average6, :average),
      ]
    end

    def name
      raise NotImplementedError
    end

    def formation(match)
      raise NotImplementedError
    end

    def errors
      [].tap do |errors|
        check_unique_captain(errors)
        check_players_count(:average, errors)
        check_players_count(:fast, errors)
      end
    end

    def valid?
      errors.empty?
    end

    def players_by_type(type)
      players.select { |p| p.type == type }
    end

    def captain_player
      players_by_type(:captain).first
    end

    private

    def game_config
      Rubygoal.configuration
    end

    def check_unique_captain(errors)
      captain_count = players_by_type(:captain).size

      if captain_count != 1
        errors << "The number of captains is #{captain_count}"
      end
    end

    def check_players_count(type, errors)
      players_count = players_by_type(type).size

      if players_count != game_config.send("#{type}_players_count")
        errors << "The number of #{type} players is #{players_count}"
      end
    end
  end
end
