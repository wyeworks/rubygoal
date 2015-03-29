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
      [].tap do |errors|
        check_unique_captain(errors)
        check_players_count(:average, errors)
        check_players_count(:fast, errors)
      end
    end

    def valid?
      errors.empty?
    end

    protected

    def mirror_formation(players_position)
      Formation.new.tap do |formation|
        mirror_positions = {}

        players_position[:average].each_with_index do |pos, i|
          mirror_positions[average_players[i]] = pos
        end
        players_position[:fast].each_with_index do |pos, i|
          mirror_positions[fast_players[i]] = pos
        end
        mirror_positions[captain_player] = players_position[:captain].first

        formation.players_position = mirror_positions
      end
    end

    private

    def game_config
      Rubygoal.configuration
    end

    def check_unique_captain(errors)
      captain_count = players[:captain].uniq.size

      if captain_count != 1
        errors << "The number of captains is #{captain_count}"
      end
    end

    def check_players_count(type, errors)
      players_count = players[type].uniq.size

      if players_count != game_config.send("#{type}_players_count")
        errors << "The number of #{type} players is #{players_count}"
      end
    end

    def player_to_mirror(player_type, average_to_add, fast_to_add)
      case player_type
      when :average
        average_to_add.shift
      when :fast
        fast_to_add.shift
      when :captain
        captain_player
      end
    end

    def average_players
      players[:average]
    end

    def fast_players
      players[:fast]
    end

    def captain_player
      players[:captain].first
    end
  end
end
